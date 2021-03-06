//
//  FeedsViewControllerTableViewController.swift
//  SwiftReader
//
//  Created by Jason Ellis on 9/17/15.
//  Copyright © 2015 Jason Ellis. All rights reserved.
//

import UIKit

class FeedsViewControllerTableViewController: UITableViewController, NSXMLParserDelegate {

    var parser:NSXMLParser = NSXMLParser()
    var feedUrl:String = String()
    
    var feedTitle:String = String()
    var articleTitle:String = String()
    var articleLink:String = String()
    var articlePubDate:String = String()
    var parsingChannel:Bool = false
    var eName:String = String()
    
    var feeds:[FeedModel] = []
    var articles:[ArticleModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        addNewFeed("https://developer.apple.com/news/rss/news.rss")
    }

    func addNewFeed(url: String) {
        feedUrl = url
        let url:NSURL = NSURL(string: feedUrl)!
        
        parser = NSXMLParser(contentsOfURL: url)!
        parser.delegate = self
        parser.parse()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func retrieveNewFeed(segue: UIStoryboardSegue) {
    
    }
    
    // NSXMLParser Delegate
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        eName = elementName
        if elementName == "channel" {
            feedTitle = ""
            feedUrl = ""
            articles = []
            parsingChannel = true
        }
        else if elementName == "item" {
            articleTitle = ""
            articleLink = ""
            articlePubDate = ""
            parsingChannel = false
        }
        
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        
        let data = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
       
        if !data.isEmpty {
            if parsingChannel {
                if eName == "title" {
                    feedTitle += data
                }
            } else {
                if eName == "title" {
                    articleTitle += data
                } else if eName == "link" {
                    articleLink += data
                } else if eName == "pubDate" {
                    articlePubDate += data
                }
            }
        }
        
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "channel" {
            let feed:FeedModel = FeedModel()
            feed.title = feedTitle
            feed.url = feedUrl
            feed.articles = articles
            feeds.append(feed)
        } else if elementName == "item" {
            let article:ArticleModel = ArticleModel()
            article.title = articleTitle
            article.link = articleLink
            article.pubDate = articlePubDate
            articles.append(article)
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return feeds.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FeedCell", forIndexPath: indexPath)

        let feed:FeedModel = feeds[indexPath.row]
        cell.textLabel!.text = feed.title
        
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "FeedToArticleSegue" {
            let articlesController:ArticlesTableViewController = segue.destinationViewController as! ArticlesTableViewController
            let indexPath = self.tableView.indexPathForSelectedRow!
            let feed = feeds[indexPath.row]
            
            articlesController.articles = feed.articles
        }
        
    }

}
