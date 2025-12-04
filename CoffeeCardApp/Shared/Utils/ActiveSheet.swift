

 enum ActiveSheet: Identifiable {
        case contentShow
        case loginNeeded
        
        var id: Int {
            switch self {
            case .contentShow: return 0
            case .loginNeeded:     return 1
            }
        }
    }
