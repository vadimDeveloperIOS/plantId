//
//  PageContainerViewController.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 8.07.25.
//

import UIKit

class PageContainerViewController: UIViewController {
    
    private lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        vc.dataSource = self
        vc.delegate = self
        return vc
    }()
    
    // Твои 5 VC (можно любые свои кастомные)
    private var pages: [UIViewController] = [ ]
    
    // Текущий индекс страницы
    private var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.frame = view.bounds
        pageViewController.didMove(toParent: self)
        setupPages()
        
        // Устанавливаем первую страницу
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
    }
    
    private func setupPages() {
        let vc1 = OnboardingFirstViewController()
        vc1.nextPageHandler = { [weak self] in
            self?.goToPage(at: 1)
        }
        let vc2 = OnboardingSecondViewController()
        vc2.nextPageHandler = { [weak self] in
            self?.goToPage(at: 2)
        }
        let vc3 = OnboardingThirdViewController()
        vc3.nextPageHandler = { [weak self] in
            self?.goToPage(at: 3)
        }
        let vc4 = PaywallViewController()
        let tab = TabsViewController()
        vc4.nextPageHandler = { [weak self] in
            self?.navigationController?.pushViewController(tab, animated: true)
        }
        let vc5 = SpecialOfferViewController()
//        vc5.nextPageHandler = { [weak self] in
//            self?.navigationController?.pushViewController(tab, animated: true)
//        }
        
        let array: [UIViewController] = [ vc1, vc2, vc3, vc4, vc5 ]
        pages = array
    }
  
    func goToPage(at index: Int, animated: Bool = true) {
        guard index >= 0, index < pages.count, index != currentIndex else { return }
        let direction: UIPageViewController.NavigationDirection = index > currentIndex ? .forward : .reverse
        pageViewController.setViewControllers([pages[index]],
                                              direction: direction,
                                              animated: animated,
                                              completion: { [weak self] completed in
            if completed {
                self?.currentIndex = index
            }
        })
    }
}

// MARK: - UIPageViewControllerDataSource

extension PageContainerViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return pages[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else {
            return nil
        }
        return pages[index + 1]
    }
}

// MARK: - UIPageViewControllerDelegate

extension PageContainerViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if completed, let visibleVC = pageViewController.viewControllers?.first,
           let index = pages.firstIndex(of: visibleVC) {
            currentIndex = index
        }
    }
}
