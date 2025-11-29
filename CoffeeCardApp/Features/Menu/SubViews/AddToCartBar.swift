import SwiftUI

struct AddToCartBar: View {
    let priceText: String        
    @Binding var quantity: Int
    let itemsInCart: Int
    let onAddToCart: () -> Void
    let onCartTap: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            
            innerContent
                .frame(maxWidth: 360.ds)
                .padding(.horizontal, 8.ds)
            
            Spacer()
        }
        .padding(.vertical, 8.ds)
    }
    
    private var innerContent: some View {
        HStack(spacing: 12.ds) {
            // MARK: Cart button
            Button(action: onCartTap) {
                ZStack {
                    Circle()
                        .fill(Color.black.opacity(0.85))
                        .frame(width: 56.ds, height: 56.ds)
                        .shadow(radius: 6.ds, y: 2.ds)
                    
                    Image(systemName: "cart")
                        .font(.system(size: 22.ds, weight: .semibold))
                        .foregroundColor(.white)
                }
                .overlay(alignment: .topTrailing) {
                    if itemsInCart > 0 {
                        Text("\(itemsInCart)")
                            .font(.system(size: 11.ds, weight: .bold))
                            .foregroundColor(.white)
                            .padding(5.ds)
                            .background(
                                Circle()
                                    .fill(Color.gray.opacity(0.9))
                            )
                            .offset(x: 6.ds, y: -6.ds)
                    }
                }
            }
            .buttonStyle(.plain)
            .contentShape(Rectangle())
            
            // MARK: Quantity stepper
            HStack(spacing: 0) {
                Button {
                    if quantity > 1 { quantity -= 1 }
                } label: {
                    Image(systemName: "minus")
                        .font(.system(size: 16.ds, weight: .bold))
                        .frame(width: 32.ds, height: 32.ds)
                }
                .buttonStyle(.plain)
                .contentShape(Rectangle())
                
                Text("\(quantity)")
                    .font(.system(size: 17.ds, weight: .semibold))
                    .frame(width: 30.ds)
                
                Button {
                    quantity += 1
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 16.ds, weight: .bold))
                        .frame(width: 32.ds, height: 32.ds)
                }
                .buttonStyle(.plain)
                .contentShape(Rectangle())
            }
            .padding(.horizontal, 10.ds)
            .padding(.vertical, 6.ds)
            .background(
                Capsule().fill(Color.secondary.opacity(0.25))
            )
            
            // MARK: Add button
            Button(action: onAddToCart) {
                HStack {
                    Text("Add")
                    Spacer()
                    Text(priceText)          // строка с уже посчитанной ценой
                }
                .font(.system(size: 17.ds, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 20.ds)
                .padding(.vertical, 12.ds)
                .frame(width: 150.ds)
            }
            .background(
                Capsule().fill(Color.orange)
            )
        }
    }
}
