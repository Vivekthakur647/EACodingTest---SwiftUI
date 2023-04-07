
import Foundation
struct URlBuilder {
    static let baseURL = "https://eacp.energyaustralia.com.au/codingtest"
}
enum EndPoints {
    //MARK: TO EA - Created this enum by considering like if there will more api's we can manage here in single place .
    case festivalList
    var path : String{
        switch self {
        case .festivalList : return "/api/v1/festivals"
        }
    }
    var url : String {
        switch self {
        case .festivalList : return "\(URlBuilder.baseURL)\(path)"
        }
    }
}

