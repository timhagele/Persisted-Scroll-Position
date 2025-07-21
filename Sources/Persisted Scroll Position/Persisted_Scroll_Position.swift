// The Swift Programming Language
// https://docs.swift.org/swift-book



import SwiftUI 

fileprivate let textFieldCount: Int = 10

@available ( iOS 15.0 , macOS 12.0 , * )
struct Maintained_Scroll_Position_Demo: View {
	@State var textItems: Array < String > = Array ( repeating: "" , count: textFieldCount )
	var body: some View {
		MaintainedScrollPosition {
		ScrollView {
			VStack ( alignment: .leading , spacing: 10 , content: {
				ForEach ( 0..<textFieldCount , id:\.self ) { i in
					MultilineTextFieldView2 ( text: self.$textItems [ i ] , placeholder: "#\( i.description ) TextField" )
				}
			} ) .navigationTitle ( "MaintainedScrollPosition" )
			}
		}
	}
}

#Preview {
	if #available ( iOS 15.0 , macOS 12.0 , * ) {
		Maintained_Scroll_Position_Demo ()
	}
	else { Text ( "err" ) }
}

@available ( iOS 15.0 , macOS 12.0 , * )
fileprivate struct MultilineTextFieldView2: View {
	@Binding var text: String
	let placeholder: String
	@FocusState private var isFocused: Bool

	var body: some View {
		
		VStack ( alignment: .leading , spacing: 5 ) {
			HStack { Text ( "Text Field" ) ; Spacer() ; Text ( "\( self.text.count ) chars" ) }
			
				TextEditor ( text: self.$text )
					.frame ( minHeight: 45 )
					.focused ( $isFocused )
					.overlay ( RoundedRectangle ( cornerRadius: 12 ) .strokeBorder ( isFocused ? Color.blue : Color.gray , lineWidth: 2 ) )
					.overlay (
						Text ( text == "" ? placeholder : "" )
							.foregroundColor ( .secondary )
							.padding ( .horizontal , 5 )
							.allowsHitTesting ( false )
							.frame ( maxWidth: .infinity , alignment: .leading )
					 )
		}
	}
}

struct MaintainedScrollPosition < V : View > : View {
 @State private var frameHeight   : Double = .zero
 @State private var viewHeight    : Double = .zero
 @State private var scrollOffset  : Double = .zero
 private var scrollRange          : Double { self.frameHeight - self.viewHeight }
 private var scrollPercentage     : Double { self.scrollOffset / self.scrollRange }
 private var content: V
	init ( @ViewBuilder _ content: @escaping () -> V ) { self.content = content() }
	var body: some View {
	 GeometryReader { frameProxy in
		 ScrollView ( .vertical, showsIndicators: true , content: {
			 self.content .padding ( 20 )
				.background (
					GeometryReader { viewProxy in
						ScrollViewReader { scrollProxy in
						Color.clear .id ( "scrollTo" )
							.onChange ( of: viewProxy.frame ( in: .named ( "scroll_id" ) ).origin.y ) { self.scrollOffset = $0 }
							.onAppear { self.viewHeight = viewProxy.size.height }
							.onChange ( of: viewProxy.size.height ) { newViewSize in
								let deltaY = newViewSize - self.viewHeight
								let translation = deltaY / ( self.frameHeight - newViewSize )
								self.viewHeight = newViewSize
								scrollProxy.scrollTo ( "scrollTo" , anchor: .init ( x: 0  , y: ( scrollPercentage - translation ) ) )
							}
							.onAppear { self.frameHeight = frameProxy.size.height }
							.onChange ( of: frameProxy.size.height ) { self.frameHeight = $0 }
						}
					}
				)
			} ) .coordinateSpace ( name: "scroll_id" )
		}
	}
}



