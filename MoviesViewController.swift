//
//  MoviesViewController.swift
//  RottenTomatoes
//
//  Created by David Fontenot on 9/19/15.
//  Copyright © 2015 David Fontenot. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var refreshControl: UIRefreshControl!

    @IBOutlet weak var tableView: UITableView!
    var movies: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenBounds = UIScreen.mainScreen().bounds
        let screenWidth = screenBounds.size.width
        let screenHeight = screenBounds.size.height

        var label = UILabel(frame: CGRectMake(0, 0, screenWidth, 21))
        label.center = CGPointMake(screenWidth/2, 75)
        label.textAlignment = NSTextAlignment.Center
        label.text = "Network Error"
        label.backgroundColor = UIColor.blackColor()
        label.textColor = UIColor.whiteColor()
        label.alpha = 0
        label.tag = 1001
        //label.bringSubviewToFront(<#T##view: UIView##UIView#>)
        self.view.addSubview(label)
        self.view.bringSubviewToFront(label)

        let tblView = self.tableView
        self.tableView.frame = CGRectMake(tblView.frame.origin.x, tblView.frame.origin.y, screenWidth, screenHeight)



        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        //prints json data from any url
        fetchData("https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json")

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Refresh
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

    func onRefresh() {
        fetchData("https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json")
        delay(2, closure: {
            self.refreshControl.endRefreshing()
        })
    }

    func fetchData(urlString: String) -> Void {
        JTProgressHUD.show()
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: urlString)
        let task = session.dataTaskWithURL(url!) {
            (data, response, error) -> Void in
            JTProgressHUD.hide()
            if error != nil {
                JTProgressHUD.hide()
                print("error in request")
                self.view.viewWithTag(1001)?.alpha = 0.75
                self.delay(10, closure: {
                    self.view.viewWithTag(1001)?.alpha = 0
                })
                print(error!.localizedDescription)
            }
            else {
                //let error: NSError?
                do {
                    self.refreshControl.endRefreshing()
                    self.view.viewWithTag(1001)?.hidden = true
                    let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                    //print(jsonData)
                    self.movies = jsonData["movies"] as! [NSDictionary]
                    
                    print(self.movies)
                    self.tableView.reloadData()
                    JTProgressHUD.hide()
                    // Do Stuff
                    
                } catch {
                    // handle error
                    JTProgressHUD.hide()
                }
            }
            JTProgressHUD.hide()
            self.tableView.reloadData()
            self.tableView.dataSource = self
            self.tableView.delegate = self
        }
        self.tableView.reloadData()
        task.resume()
        JTProgressHUD.hide()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (movies != nil) {
            return movies!.count
        } else {
            return 0
        }

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movie = movies![indexPath.row]
        
        cell.titleLabel?.text = movie["title"] as? String
        cell.descriptionLabel.text = movie["synopsis"] as? String
        
        let url = NSURL(string: movie.valueForKeyPath("posters.thumbnail") as! String)!

        cell.posterView.setImageWithURL(url)
        //cell.contentView.width

        return cell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }


    //MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)!

        let movie = movies![indexPath.row]

        let movieDetailsViewController = segue.destinationViewController as! MovieDetailsViewController
        movieDetailsViewController.movie = movie


        print("about to segue")
    }



    
    

}
