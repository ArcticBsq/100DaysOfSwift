//
//  ViewController.swift
//  Project4_Wrap
//
//  Created by Илья Москалев on 02.03.2021.
//

import UIKit
import  WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var progressView: UIProgressView!
    
    var website: String?
    var sites = [String]()
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://" + website!)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        let goBackButton = UIBarButtonItem(title: "<", style: .done, target: webView, action: #selector(webView.goBack))
        let goForwardButton = UIBarButtonItem(title: ">", style: .done, target: webView, action: #selector(webView.goForward))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) // В нижнем тулбаре делает пробел, который занимает все доступное место
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload)) //  В нижнем тулбаре кнопка обноваить страницу
        
        toolbarItems = [goBackButton, progressButton, goForwardButton, spacer, refresh] // создаем тулбар, грубо говоря между квадратных скобок - все элементы тулбара, по порядку
        navigationController?.isToolbarHidden = false // делаем тулбар видимым, так он есть по дефолту?
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }

    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
//        ac.addAction(UIAlertAction(title: "apple.com", style: .default, handler: openPage))
//        ac.addAction(UIAlertAction(title: "hackingwithswift.com", style: .default, handler: openPage))
        for website in sites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
        
    }
    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) { // Title of the webView gets visible and equals to website's title
        title = webView.title
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let url = navigationAction.request.url // присваеваем местному url значение url из navigationController
        
        if let host = url?.host { // Извлекаем опционал из параметра url?.host (например apple.com), опционал потому что не каждый URL имеет host
            for website in sites {
                if host.contains(website) { // Здесь у нас идет проверка, мы проверяем есть ли кусок нашего URL в списке доверенных сайтов.ж
                    decisionHandler(.allow) // Если он есть, разрешаем переход
                    return
                }
            }
        }
        decisionHandler(.cancel) // Если сайта нет в разрешенных, не даем перейти
        let alert = UIAlertController(title: "OOPS", message: "The URL you are trying to load is blocked", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
}


