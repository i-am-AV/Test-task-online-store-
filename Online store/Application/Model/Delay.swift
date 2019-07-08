import Foundation

class After {
     static func delay(_ delay: Int, clousure: @escaping () -> ()) {
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(delay)) {
            clousure()
        }
    }
}


