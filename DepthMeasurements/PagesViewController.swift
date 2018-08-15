//
//  PagesViewController.swift
//  DepthMeasurements
//
//  Created by Jukka Aittola on 09/08/2018.
//  Copyright © 2018 Jukka Aittola. All rights reserved.
//

import UIKit

class PagesViewController: UIPageViewController, UIPageViewControllerDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        setViewControllers([pages.first!], direction: .forward, animated: true, completion: nil)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let idx = pages.index(of: viewController) else {
            return nil
        }
        let nextIdx = (idx + 1) % pages.count
        return pages[nextIdx]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let idx = pages.index(of: viewController) else {
            return nil
        }
        let nextIdx = idx - 1
        if (nextIdx < 0) {
            return pages.last
        } else {
            return pages[nextIdx]
        }
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return pages.index(of: pageViewController) ?? 0
    }

    internal lazy var pages: [UIViewController] = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return [ storyboard.instantiateViewController(withIdentifier: "MapViewController") ,
                 storyboard.instantiateViewController(withIdentifier: "MeasurementNavigation")]
    }()
}

