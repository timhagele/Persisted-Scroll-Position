// The Swift Programming Language
// https://docs.swift.org/swift-book



import SwiftUI 



@available ( iOS 15.0 , macOS 12.0 , * )
struct Maintained_Scroll_Position_Demo: View {
	@State var text1: String = ""
	@State var text2: String = ""

	var body: some View {
		NavigationView {
			MaintainedScrollPosition {
				VStack ( alignment: .leading , spacing: 10 , content: {
					MultilineTextFieldView2 ( text: self.$text1 , placeholder: "#1" )
					MultilineTextFieldView2 ( text: self.$text2 , placeholder: "#2" )
				} )
				.navigationTitle ( "MaintainedScrollPosition" )
			}
		}
	}
}

#Preview {
	if #available ( iOS 15.0 , macOS 12.0 , * ) {
		Maintained_Scroll_Position_Demo ()
	} else {
		Text ( "err" )
	}
}






@available ( iOS 15.0 , macOS 12.0 , * )
fileprivate struct MultilineTextFieldView2: View {
	@Binding var text: String
	let placeholder: String
	@FocusState private var isFocused: Bool

	var body: some View {
		VStack ( alignment: .leading , spacing: 5 ) {
			HStack {
				Text ( "Text Field" )
				Spacer()
				Text ( "\( self.text.count ) chars" )
			}

			TextEditor ( text: self.$text )
				.frame ( minHeight: 35 )
				.focused ( $isFocused )
				.overlay (
					RoundedRectangle ( cornerRadius: 12 )
						.strokeBorder ( isFocused ? Color.blue : Color.gray , lineWidth: 2 )
				)
				.overlay (
					Text ( text == "" ? placeholder : "" )
						.foregroundColor ( .secondary )
						.padding ( .horizontal , 5 )
						.allowsHitTesting ( true )
						.frame ( maxWidth: .infinity , alignment: .leading )
				)
		}
	}
}

struct MaintainedScrollPosition < V : View > : View {
	@State private var frameHeight      : Double = .zero
	@State private var viewHeight       : Double = .zero
	@State private var scrollOffset     : Double = .zero

	private var scrollRange             : Double { self.frameHeight - self.viewHeight }
	private var scrollPercentage        : Double { self.scrollOffset / self.scrollRange }

	var content: V

	init ( @ViewBuilder _ content: @escaping () -> V ) { self.content = content() }

	var body: some View {
		GeometryReader { frameProxy in
			ScrollView ( .vertical , showsIndicators: true , content: {
				self.content .padding ( 20 )
					.background (
						GeometryReader { viewProxy in
							ScrollViewReader { scrollProxy in
								Color.clear .id ( "scrollTo" )
									
									.onChange ( of: viewProxy.frame ( in: .named ( "scroll_id" ) ).origin.y ) {
										self.scrollOffset = $0
									}
									.onChange ( of: viewProxy.size.height ) { newViewSize in
											let deltaY = newViewSize - self.viewHeight
											let translation = deltaY / ( self.frameHeight - newViewSize )
											self.viewHeight = newViewSize
										DispatchQueue.main.async {
											scrollProxy.scrollTo ( "scrollTo" , anchor: .init ( x: 1 , y: ( scrollPercentage - translation ) ) )
										}
									}
									.onChange ( of: frameProxy.size.height ) {
										self.frameHeight = $0
									}
							}
						}
					)
			} )
			.coordinateSpace ( name: "scroll_id" )
		}
	}
}

