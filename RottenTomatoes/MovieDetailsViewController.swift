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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var movie: NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()

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
