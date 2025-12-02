import Foundation
import Observation

@Observable
final class CustomTabViewModel {
    var selected: CustomTabModel = .home
    let tabs: [CustomTabModel] = CustomTabModel.allCases
}
