import SwiftUI

struct HomeView: View {
    @State var showQRCard: Bool = false
    @ObservedObject var promoViewModel: PromoViewModel
    @EnvironmentObject var session: SessionViewModel
    
    var body: some View {
        VStack {
            HeaderView()
            PromoCarouselView(promoViewModel: promoViewModel)
            HStack {
                
            }
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .top)
    }
}
