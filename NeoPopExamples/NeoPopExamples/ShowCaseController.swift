//
//  ShowCaseController.swift
//  NeoPopExamples
//
//  Created by Somesh Karthik on 30/05/22.
//  Copyright © 2022 Dreamplug. All rights reserved.
//

import UIKit

final class ShowCaseController: UIViewController {
    private let contentLayoutGuide = UILayoutGuide()

    // MARK: Views
    private let bottomCubes: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "bottom_cubes")!
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let spotlightLeft: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "spotlight")!
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let spotlightRight: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "spotlight")!.withHorizontallyFlippedOrientation()
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let navigationStackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fill
        view.axis = .horizontal
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let showCaseView = ShowCaseView()

    // MARK: Constraints
    private var contentLayoutLeadingConstraint: NSLayoutConstraint!
    private var contentLayoutTrailingConstraint: NSLayoutConstraint!
    private var contentLayoutTopConstraint: NSLayoutConstraint!
    private var contentLayoutBottomConstraint: NSLayoutConstraint!

    private var bottomCubeHeightConstraint: NSLayoutConstraint?

    // MARK: Child Controllers
    private let welcomeController = WelcomeViewController()

    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)

    private var paginatedControllers = [UIViewController]()

    // MARK: Size Constants
    private var bottomThickness: CGFloat { view.layoutMarginsGuide.layoutFrame.height * 0.15 }
    private var edgeThickness: CGFloat { view.layoutMarginsGuide.layoutFrame.width * 0.1 }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorHelper.contentBackgroundColor

        welcomeController.delegate = self

        view.addLayoutGuide(contentLayoutGuide)
        contentLayoutBottomConstraint = contentLayoutGuide.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -bottomThickness)
        contentLayoutTopConstraint = contentLayoutGuide.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: edgeThickness)
        contentLayoutLeadingConstraint = contentLayoutGuide.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: edgeThickness)
        contentLayoutTrailingConstraint = contentLayoutGuide.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -edgeThickness)

        NSLayoutConstraint.activate([
            contentLayoutLeadingConstraint,
            contentLayoutTrailingConstraint,
            contentLayoutTopConstraint,
            contentLayoutBottomConstraint
        ])

        let backgroundView = UIView()
        backgroundView.backgroundColor = ColorHelper.contentBackgroundColor
        view.addSubview(backgroundView)
        backgroundView.fill(in: contentLayoutGuide)

        addWelcomeController()
        addPageController()

        addShowCaseView()

        addBottomCubes()
        addSpotlights()

        addNavigationButtons()

        hidePageController()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomCubeHeightConstraint?.constant = bottomThickness * 0.60
        showCaseView.applyStyle(ShowCaseViewModel(fillColorModel: ColorModel(top: ColorHelper.contentBackgroundColor, left: ColorHelper.contentBackgroundColor, right: ColorHelper.contentBackgroundColor, bottom: ColorHelper.contentBackgroundColor), strokeColorModel: UIColor.fromHex("#434343"), borderThickness: 0.5, edgeThickness: edgeThickness, bottomEdgeThickness: bottomThickness))

        contentLayoutBottomConstraint.constant = -bottomThickness
        contentLayoutTopConstraint.constant = edgeThickness
        contentLayoutLeadingConstraint.constant = edgeThickness
        contentLayoutTrailingConstraint.constant = -edgeThickness
    }
}

// MARK: PageController DataSource
extension ShowCaseController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        getPreviousController(from: viewController)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        getNextController(from: viewController)
    }

    @objc
    private func moveToNextController() {
        guard let controller = pageViewController.viewControllers?.first,
              let nextController = getNextController(from: controller) else {
            return
        }

        pageViewController.setViewControllers([nextController], direction: .forward, animated: true)
    }

    @objc
    private func moveToPreviousController() {
        guard let controller = pageViewController.viewControllers?.first,
              let nextController = getPreviousController(from: controller) else {
            return
        }

        pageViewController.setViewControllers([nextController], direction: .reverse, animated: true)
    }

    private func getNextController(from controller: UIViewController) -> UIViewController? {
        guard let viewControllerCurrentIndex = paginatedControllers.firstIndex(of: controller) else {
            return nil
        }

        let previousIndex = viewControllerCurrentIndex + 1

        let validIndex = mod(previousIndex, paginatedControllers.count)

        return paginatedControllers[validIndex]
    }

    private func getPreviousController(from controller: UIViewController) -> UIViewController? {
        guard let viewControllerCurrentIndex = paginatedControllers.firstIndex(of: controller) else {
            return nil
        }

        let previousIndex = viewControllerCurrentIndex - 1

        let validIndex = mod(previousIndex, paginatedControllers.count)

        return paginatedControllers[validIndex]
    }
}

// MARK: Welcome Button Delegate Methods
extension ShowCaseController: WelcomeViewControllerDelegate {
    func mainButtonClicked() {
        showPageController()
        let controller = paginatedControllers[0]
        pageViewController.setViewControllers([controller], direction: .forward, animated: false)
    }

    func primaryButtonClicked() {
        showPageController()
        let controller = paginatedControllers[1]
        pageViewController.setViewControllers([controller], direction: .forward, animated: false)
    }

    func secondaryButtonClicked() {
        showPageController()
        let controller = paginatedControllers[2]
        pageViewController.setViewControllers([controller], direction: .forward, animated: false)
    }

    func switchButtonClicked() {
        showPageController()
        let controller = paginatedControllers[3]
        pageViewController.setViewControllers([controller], direction: .forward, animated: false)
    }
}

// MARK: PageController Visibility Method
private extension ShowCaseController {
    @objc
    func hidePageController() {
        pageViewController.view.isHidden = true
        navigationStackView.isHidden = true
        welcomeController.view.isHidden = false
    }

    func showPageController() {
        welcomeController.view.isHidden = true
        pageViewController.view.isHidden = false
        navigationStackView.isHidden = false
    }
}

// MARK: View setup methods
private extension ShowCaseController {
    func addWelcomeController() {
        addChild(welcomeController)
        view.addSubview(welcomeController.view)
        welcomeController.view.fill(in: contentLayoutGuide)
        welcomeController.didMove(toParent: self)
    }

    func addPageController() {
        pageViewController.dataSource = self

        paginatedControllers = [
            FloatingButtonsViewController(),
            PopButtonsViewController(),
            AdvancedButtonsViewController(),
            SwitchesViewController()
        ]
        view.addSubview(navigationStackView)

        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: navigationStackView.topAnchor)
        ])
        pageViewController.didMove(toParent: self)
        pageViewController.setViewControllers([paginatedControllers.first!], direction: .forward, animated: false)
    }

    func addShowCaseView() {
        showCaseView.isUserInteractionEnabled = false
        showCaseView.applyStyle(ShowCaseViewModel(fillColorModel: ColorModel(top: .black, left: .black, right: .black, bottom: UIColor.fromHex("#060606")), strokeColorModel: UIColor.fromHex("#434343"), borderThickness: 0.5, edgeThickness: edgeThickness, bottomEdgeThickness: bottomThickness))
        view.addSubview(showCaseView)
        showCaseView.fill(in: view.layoutMarginsGuide)
    }

    func addBottomCubes() {
        view.addSubview(bottomCubes)
        bottomCubes.translatesAutoresizingMaskIntoConstraints = false
        bottomCubeHeightConstraint = bottomCubes.heightAnchor.constraint(equalToConstant: bottomThickness * 0.60)
        NSLayoutConstraint.activate([
            bottomCubes.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -bottomThickness * 0.25),
            bottomCubeHeightConstraint!,
            bottomCubes.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            bottomCubes.widthAnchor.constraint(equalTo: bottomCubes.heightAnchor, multiplier: 4)
        ])
    }

    func addSpotlights() {
        view.addSubview(spotlightLeft)
        spotlightLeft.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spotlightLeft.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            spotlightLeft.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
        ])

        view.addSubview(spotlightRight)
        spotlightRight.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spotlightRight.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            spotlightRight.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }

    func addNavigationButtons() {
        view.bringSubviewToFront(navigationStackView)
        NSLayoutConstraint.activate([
            navigationStackView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            navigationStackView.heightAnchor.constraint(equalToConstant: 40),
            navigationStackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.leadingAnchor),
            navigationStackView.bottomAnchor.constraint(equalTo: welcomeController.view.bottomAnchor, constant: -20)
        ])

        let moveLeftButton = UIButton()
        moveLeftButton.setImage(UIImage(named: "chevron_left"), for: .normal)
        moveLeftButton.addTarget(self, action: #selector(moveToPreviousController), for: .touchUpInside)
        navigationStackView.addArrangedSubview(moveLeftButton)

        let closeButton = UIButton()
        closeButton.addTarget(self, action: #selector(hidePageController), for: .touchUpInside)
        closeButton.setImage(UIImage(named: "cross"), for: .normal)
        navigationStackView.addArrangedSubview(closeButton)

        let moveRightButton = UIButton()
        moveRightButton.addTarget(self, action: #selector(moveToNextController), for: .touchUpInside)
        moveRightButton.setImage(UIImage(named: "chevron_right"), for: .normal)
        navigationStackView.addArrangedSubview(moveRightButton)
    }
}

/// Swift modulo operator doesn't work well with negative numbers.
/// it performs modulo like this `a % b = a - (a/b) * b`
/// eg: `(-1) % 3 = (-1) - ((-1)/3) * 3 = (-1) - 0 * 3 = -1`
///
/// But a true modulo of `-1%3` will be `2`
///
/// So this function is used to achieve true modulo
/// refered from `https://stackoverflow.com/questions/41180292/negative-number-modulo-in-swift`
public func mod(_ a: Int, _ n: Int) -> Int {
    precondition(n > 0, "denominator must be positive")
    let r = a % n
    return r >= 0 ? r : r + n
}
