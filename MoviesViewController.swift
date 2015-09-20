//
//  MoviesViewController.swift
//  RottenTomatoes
//
//  Created by David Fontenot on 9/19/15.
//  Copyright © 2015 David Fontenot. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var movies: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //prints json data from any url
        fetchData("https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json")

        // Do any additional setup after loading the view.
    }
    
    func fetchData(urlString: String) -> Void {
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: urlString)
        let task = session.dataTaskWithURL(url!) {
            (data, response, error) -> Void in
            
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                //let error: NSError?
                do {
                    let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
                    //print(jsonData)
                    self.movies = jsonData["movies"] as! [NSDictionary]
                    
                    print(self.movies)
                    self.tableView.reloadData()
                    // Do Stuff
                    
                } catch {
                    // handle error
                }
            }
            self.tableView.dataSource = self
            self.tableView.delegate = self
        }
        
        task.resume()
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
        
        return cell
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
