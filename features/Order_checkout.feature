Feature: Order checkout

    As a USER 
    i want to BE NOTIFIED WITH A MESSAGE WHEN I COMPLETE AN ORDER 
    so that i can VERIFY THE SUCCESS OF THE ORDER

    Scenario: Order checkout and notification
      Given i am logged in as an User
        And The user is on the cart page
        And there is at least a LineItem
      When The user press "Proceed to checkout"
        And The user fill the order form
        And The user press "Submit Order"
      Then The user should be on the Homepage
        And The user should see "Order completed"