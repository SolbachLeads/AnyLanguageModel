#if canImport(AsyncHTTPClient)
    import AsyncHTTPClient

    import Logging
    import NIOCore

    public typealias SessionType = HTTPClient

    private let anyLanguageModelSharedHttpClient: HTTPClient = {
        let loggingDisabled = Logger(label: "AHC-do-not-log", factory: { _ in SwiftLogNoOpLogHandler() })
        let httpClient = HTTPClient(
            eventLoopGroup: HTTPClient.defaultEventLoopGroup,
            configuration: HTTPClient.Configuration(
                certificateVerification: .fullVerification,
                redirectConfiguration: .follow(max: 20, allowCycles: false),
                timeout: HTTPClient.Configuration.Timeout(connect: .seconds(1800), read: .seconds(1800)),
                connectionPool: .seconds(600),
                proxy: nil,
                ignoreUncleanSSLShutdown: false,
                decompression: .enabled(limit: .ratio(25)),
                backgroundActivityLogger: loggingDisabled,
            ),
            backgroundActivityLogger: loggingDisabled,
        )
        return httpClient
    }()

    public func makeDefaultSession() -> SessionType {
        return anyLanguageModelSharedHttpClient
    }
#else
    import Foundation
    #if canImport(FoundationNetworking)
        import FoundationNetworking
    #endif

    public typealias SessionType = URLSession

    public func makeDefaultSession() -> SessionType {
        return URLSession(configuration: .default)
    }
#endif
