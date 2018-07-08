Feature: Order checkout

    As a USER 
    i want to BE NOTIFIED WITH A MESSAGE WHEN I COMPLETE AN ORDER 
    so that i can VERIFY THE SUCCESS OF THE ORDER

    Scenario: Order checkout and notification
      Given I am on the cart page
        And I am logged in user
        And there is at least a LineItem
      When I press "Checkout"
        And I fill the order form
        And I press "Order"
      Then I should be on the Homepage
        And I should see "Order completed"