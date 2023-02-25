/*
 1. Better lists
 - loading async images with AsyncImnage(url:) view component
 - .refreshable modifier for async/await (swift 5.5)
 - .task modifier - attach async task (starts on view's load and cancel on view's removed)
 - better providing binding of collection into list by List($items) { $item in ... } or ForEach($items) { $item in ... }
 - .listRowSeparatorTint modifier change coloer of idevidual row separators or hidden
 - .swipeActions modifier for swipes gestures

 2. Beyond lists
 - Table and TableColumn views for MacOS (support for sort and selection)
 - support for CoreData FetchRequests
 - @SectionedFetchRequest for iOS
 - .searchable modeifier (add search field into proper place)
 - drag and drop with previews on MacOS
 
 3. Advanced graphics
 - SFSymbols new rendering modes: monochrome, multicolor, hierarchical, palette
 - Canvas view for drawing on context with gestures support
 - TimelineView - for screen savers, preview content per schedule type selection
 - .privacySensitive modifier (widgets or WatchKit)
 - support for background materials
 
 4. Text and keyboard
 - support for markdown (Whats new in foundation 2021)
 - dynamic type size range support for Accessibility
 - TextField support for format styles
 - TextField promt/placeholder support
 - .onSubmit modifier for TextField
 - .submitLabel modifier for TextField
 - @FocusState wrapper for moving focus with keyboards
 
 5. More buttons
 - standard bordered buttons with .buttonStyle(.bordered)
 - .contenlSize(.small/.large)
 - .controlProminence(.increased)
 - .tint(.accentColor)
 - text labels for max width .frame(maxWidth: 300)
 - .keyboardShortcut(.defaultAction)
 - .confirmationDialog modifier for conext menu
 - Button("Delete", role: .descructive) for roles support (iPad popover, Mac SheetAlert, iOS SheetAlert)
 - Menu("Add") buttons for showing menu
 - .toggleStyle for toggle on/off styles
 - ControlGroup button
 */
