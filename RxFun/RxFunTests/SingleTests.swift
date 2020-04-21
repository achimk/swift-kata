//
//  Created by Joachim Kret on 09/04/2020.
//  Copyright © 2020 Joachim Kret. All rights reserved.
//

import XCTest
import Nimble
import RxSwift
import RxCocoa
import CoreKit

final class SingleTests: XCTestCase {
    
    struct TestError: Error { }
    
    private var bag = DisposeBag()
    
    override func tearDown() {
        bag = DisposeBag()
    }
    
    func testSubscribe() {
        
        var result: Result<Int, Error>!
        
        Single
            .just(1)
            .subscribe(onSuccess: { result = .success($0) }, onError: { result = .failure($0) })
            .disposed(by: bag)
        
        expect(result.isSuccess) == true
    }
    
    func testResultSubscribe() {
        
        var result: Result<Int, Error>!
        let completion: (Result<Int, Error>) -> () = {
            result = $0
        }
        
        Single
            .just(1)
            .subscribe(completion: completion)
            .disposed(by: bag)
        
        expect(result.isSuccess) == true
    }
}

extension PrimitiveSequenceType where Self.Trait == RxSwift.SingleTrait {
    
    func subscribe(completion: @escaping (Result<Element, Error>) -> ()) -> Disposable {
        return self.subscribe(onSuccess: { completion(.success($0)) }, onError: { completion(.failure($0)) })
    }
}
