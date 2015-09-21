//
//  MovieDetailsViewController.swift
//  RottenTomatoes
//
//  Created by David Fontenot on 9/20/15.
//  Copyright © 2015 David Fontenot. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentsView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var movie: NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()

        let screenBounds = UIScreen.mainScreen().bounds
        let screenWidth = screenBounds.size.width
        let screenHeight = screenBounds.size.height

        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, screenWidth, screenHeight)

        self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, screenWidth, self.imageView.frame.height)

        self.commentsView.frame = CGRectMake(self.commentsView.frame.origin.x, self.commentsView.frame.origin.y, screenWidth, self.commentsView.frame.height)
//
//        self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y, screenWidth, self.titleLabel.frame.height)
//        self.descriptionLabel.frame = CGRectMake(self.descriptionLabel.frame.origin.x, self.descriptionLabel.frame.origin.y, screenWidth, self.descriptionLabel.frame.height)

        titleLabel.text = movie["title"] as? String
        descriptionLabel.text = movie["synopsis"] as? String

        let highResString = (movie.valueForKeyPath("posters.thumbnail") as! String).stringByReplacingOccurrencesOfString("tmb", withString: "ori")
        //print(highResString)

        let url = NSURL(string: highResString)!

        imageView.setImageWithURL(url)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
