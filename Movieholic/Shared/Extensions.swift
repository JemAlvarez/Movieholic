import SwiftUI

//MARK: - View
extension View { // customize window
    func hostingWindowFinder() -> some View {
        self.overlay(
            HostingWindowFinder { window in
              if let window = window {
                  window.titlebarAppearsTransparent = true
                  window.titleVisibility = .hidden
              }
            }
        )
    }
}

extension View { // set window translucent background
    func windowBackground() -> some View {
        self.background(
            VisualEffect(material: .popover, blendingMode: .behindWindow)
                .ignoresSafeArea()
        )
    }
}

extension View { // change cursor
    func changeNSCursor(to cursor: NSCursor, for bool: Bool) {
        DispatchQueue.main.async {
            bool ? cursor.push() : NSCursor.pop()
        }
    }
}

extension View { // get window/screensize size
    func getViewSize(completion: @escaping ((width: CGFloat, height: CGFloat)) -> Void) -> some View {
        GeometryReader { geo in
            Text("")
                .onChange(of: geo.size.width) { newValue in
                    completion((newValue, geo.size.height))
                }
                .onChange(of: geo.size.height, perform: { newValue in
                    print("height", newValue)
                    completion((geo.size.width, newValue))
                })
                .onAppear {
                    completion((geo.size.width, geo.size.height))
                }
        }
        .frame(maxHeight: .infinity)
    }
}

extension View {
    // routing for inner views
    func onRouteChange(currentRoute: Routes?, callback: @escaping (Int) -> Void) -> some View {
        self
            .onChange(of: currentRoute) { newValue in
                switch newValue {
                case .movie(let newId):
                    callback(newId)
                case .tv(let newId):
                    callback(newId)
                case .people(let newId):
                    callback(newId)
                default:
                    break
                }
            }
    }
}

//MARK: - Date
extension Date {
    // get string from date
    func getString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
}

//MARK: - String
extension String {
    // get date from string
    func getDate(format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.date(from: self)
    }
}

//MARK: - Int
extension Int {
    // get hours and minutes
    func minutesToHoursAndMinutes() -> String {
        let hours = self / 60
        let minutes = self % 60
        
        if minutes < 10 {
            return "\(hours):0\(minutes) hrs"
        } else {
            return "\(hours):\(minutes) hrs"
        }
    }
    
    // change to currency format
    func getCurrencyForamt() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        return self == 0 ? "-" : formatter.string(from: self as NSNumber)
    }
}
