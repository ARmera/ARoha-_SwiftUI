import SwiftUI
import UIKit
import AVFoundation
import WebKit
class PreviewView: UIView {
    private var captureSession: AVCaptureSession?

    init() {
        super.init(frame: .zero)

        var allowedAccess = false
        let blocker = DispatchGroup()
        blocker.enter()
        AVCaptureDevice.requestAccess(for: .video) { flag in
            allowedAccess = flag
            blocker.leave()
        }
        blocker.wait()

        if !allowedAccess {
            print("!!! NO ACCESS TO CAMERA")
            return
        }

        // setup session
        let session = AVCaptureSession()
        session.beginConfiguration()

        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
            for: .video, position: .unspecified) //alternate AVCaptureDevice.default(for: .video)
        guard videoDevice != nil, let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!), session.canAddInput(videoDeviceInput) else {
            print("!!! NO CAMERA DETECTED")
            return
        }
        session.addInput(videoDeviceInput)
        session.commitConfiguration()
        self.captureSession = session
    }

    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        if nil != self.superview {
            self.videoPreviewLayer.session = self.captureSession
            self.videoPreviewLayer.videoGravity = .resizeAspect
            self.captureSession?.startRunning()
        } else {
            self.captureSession?.stopRunning()
        }
    }
}

struct PreviewHolder: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<PreviewHolder>) -> PreviewView {
        PreviewView()
    }

    func updateUIView(_ uiView: PreviewView, context: UIViewRepresentableContext<PreviewHolder>) {
    }

    typealias UIViewType = PreviewView
}

struct DemoVideoStreaming: View {
    var body: some View {
        VStack {
            PreviewHolder()
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
    }
}

class ViewContoller:UIViewController,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler{
    @IBOutlet weak var containerView:UIView!
    var webView: WKWebView!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func loadView() {
        super.loadView()
        
        let contentController = WKUserContentController()
        let config = WKWebViewConfiguration()
        
        // native -> js call (문서 시작시에만 가능한, 환경설정으로 사용함), source부분에 함수 대신 HTML직접 삽입 가능
        let userScript = WKUserScript(source: "redHeader()", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        contentController.addUserScript(userScript)
        
        // js -> native call : name의 값을 지정하여, js에서 webkit.messageHandlers.NAME.postMessage("");와 연동되는 것, userContentController함수에서 처리한다
        contentController.add(self, name: "callbackHandler")
        
        config.userContentController = contentController
        

        webView = WKWebView(frame: self.containerView.frame, configuration: config)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        // self.view = self.webView!
        self.view.addSubview(webView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myBlog = "test.html"
        let url = URL(string: myBlog)
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
    @available(iOS 8.0, *)
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Swift.Void){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let otherAction = UIAlertAction(title: "OK", style: .default, handler: {action in completionHandler()})
        alert.addAction(otherAction)
            
        self.present(alert, animated: true, completion: nil)
    }

    // JS -> Native CALL
    @available(iOS 8.0, *)
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage){
        if(message.name == "callbackHandler"){
            print(message.body)
            abc()
        }
    }
    
    func abc(){
        print("abc call")
    }
}
