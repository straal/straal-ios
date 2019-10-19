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

internal class Straal3DSViewController: UIViewController {

	// MARK: Views
	private var webView: WKWebView!
	private var activityIndicator: UIActivityIndicatorView!

	// MARK: Properties
	private let completion: (Encrypted3DSOperationStatus) -> Void
	private let context: Init3DSContext
	private var result: Encrypted3DSOperationStatus?

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
		view = UIView()
		webView = Subviews.webView
		activityIndicator = Subviews.activityIndicator
		view.addSubview(webView)
		view.addSubview(activityIndicator)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		webView.navigationDelegate = self
		webView.load(URLRequest(url: context.redirectURL, cachePolicy: .reloadIgnoringCacheData))
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		webView.frame = view.bounds
		activityIndicator.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		if result == nil {
			result = .failure
			callCompletion()
		}
	}

	private func callCompletion() {
		let result = self.result ?? Encrypted3DSOperationStatus.failure
		completion(result)
	}

	private func dismissWithCompletion() {
		dismiss(animated: true) { () in self.callCompletion() }
	}
}

extension Straal3DSViewController: WKNavigationDelegate {
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		switch navigationAction.request.url {
		case context.successURL:
			result = .success
			decisionHandler(.cancel)
			dismissWithCompletion()
		case context.failureURL:
			result = .failure
			decisionHandler(.cancel)
			dismissWithCompletion()
		default:
			decisionHandler(.allow)
		}
	}

	func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
		result = .failure
		dismissWithCompletion()
	}

	func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
		activityIndicator.startAnimating()
	}

	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		activityIndicator.stopAnimating()
	}
}

private enum Subviews {
	static var webView: WKWebView {
		let webView = WKWebView()
		webView.allowsLinkPreview = false
		webView.allowsBackForwardNavigationGestures = false
		return webView
	}

	static var activityIndicator: UIActivityIndicatorView {
		let activityIndicator = UIActivityIndicatorView(style: .gray)
		activityIndicator.hidesWhenStopped = true
		return activityIndicator
	}
}
