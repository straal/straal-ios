//
/*
 * Straal3DSViewController.swift
 * Created by Michał Dąbrowski on 19/10/2019.
 *
 * Straal SDK for iOS
 * Copyright 2019 Straal Sp. z o. o.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or  * implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import UIKit
import WebKit

class Straal3DSViewController: UIViewController, WKNavigationDelegate {

	private var webView: WKWebView!
	private let context: Init3DSContext
	private let completion: (Encrypted3DSOperationStatus) -> Void
	private var activityIndicator: UIActivityIndicatorView!

	init(context: Init3DSContext, completion: @escaping (Encrypted3DSOperationStatus) -> Void) {
		self.context = context
		self.completion = completion
		super.init(nibName: nil, bundle: nil)
		self.title = "Straal 3D Secure"
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func loadView() {
		self.view = UIView()
		webView = WKWebView()
		activityIndicator = .init(style: .gray)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(webView)
		view.addSubview(activityIndicator)
		webView.navigationDelegate = self
		activityIndicator.hidesWhenStopped = true
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		webView.frame = view.bounds
		activityIndicator.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		activityIndicator.startAnimating()
		webView.load(URLRequest(url: context.redirectURL, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 50))
	}

	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		switch navigationAction.request.url {
		case context.successURL:
			decisionHandler(.cancel)
			dismiss(animated: true) { [completion] () in completion(.success) }
		case context.failureURL:
			decisionHandler(.cancel)
			dismiss(animated: true) { [completion] () in completion(.failure) }
		default:
			decisionHandler(.allow)
		}
	}

	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		activityIndicator.stopAnimating()
	}
}
