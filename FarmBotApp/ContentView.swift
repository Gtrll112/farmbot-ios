import SwiftUI
import WebKit

struct ContentView: View {
    // 面板地址：外网穿透
    private let targetURL = URL(string: "http://frp-six.com:64450")!
    // 自动登录账号密码
    private let username = "admin"
    private let password = "880828"

    var body: some View {
        WebView(url: targetURL, username: username, password: password)
            .edgesIgnoringSafeArea(.all)
            .statusBar(hidden: true)
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    let username: String
    let password: String

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()

        // 注入自动登录脚本（页面加载完成后执行）
        let autoLoginJS = """
        (function() {
            if (localStorage.getItem('admin_token')) return;
            fetch('/api/login', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify({username: '\(username)', password: '\(password)'})
            })
            .then(function(r){ return r.json(); })
            .then(function(data) {
                if (data.ok && data.data && data.data.token) {
                    localStorage.setItem('admin_token', data.data.token);
                    localStorage.setItem('user_info', JSON.stringify({
                        username: 'admin', role: 'admin', card: null,
                        accountLimit: data.data.accountLimit, mustChangePassword: false
                    }));
                    location.href = '/';
                }
            })
            .catch(function(e){ console.log('Auto login failed:', e); });
        })();
        """

        let userScript = WKUserScript(
            source: autoLoginJS,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true
        )
        config.userContentController.addUserScript(userScript)

        // 允许非 HTTPS（NSAppTransportSecurity 已在 Info.plist 配置）
        config.preferences.javaScriptCanOpenWindowsAutomatically = true

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.allowsBackForwardNavigationGestures = true
        webView.allowsLinkPreview = false
        webView.scrollView.bounces = false

        // 自定义 User-Agent，标识为 iOS App
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 FarmBot/1.0"

        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // 无需更新
    }
}
