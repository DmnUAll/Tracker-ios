import Foundation
import YandexMobileMetrica

struct AnalyticsService {
    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: K.Keys.api) else { return }
        YMMYandexMetrica.activate(with: configuration)
    }

    func report(event: String, params: [AnyHashable: Any]) {
        print("\nEvent: ", event)
        print("Params: ", params, "\n")
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
