import SwiftUI

struct HomeView: View {
    @ObservedObject var promoViewModel: PromoViewModel
    @EnvironmentObject var session: SessionViewModel
    @Binding var isTabBarHidden: Bool
    
    var body: some View {
        VStack {
            HeaderView()
            PromoCarouselView(promoViewModel: promoViewModel)
            
            HStack {
                QrCodeFinalView(isTabBarHidden: $isTabBarHidden)
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray)
                    .frame(width: 180.ds, height: 180.ds)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity,
                   alignment: .top)
        }
    }
}


