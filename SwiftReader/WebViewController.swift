//
//  WebViewController.swift
//  SwiftReader
//
//  Created by Jason Ellis on 9/17/15.
//  Copyright © 2015 Jason Ellis. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    var article:ArticleModel = ArticleModel()
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = article.title
        let nsUrl = NSURL(string: article.link)!
        let nsUrlRequest:NSURLRequest = NSURLRequest(URL: nsUrl)
        
        webView.loadRequest(nsUrlRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
