Feature: Order checkout

    As a User 
    I want to be notified with a message when i complete an order 
    So that i can verify the success of the order


Scenario: Order checkout and notification
  Given i am logged in as an User
    And i have added an item in the cart
   Then i should be into the current cart page
    And i should see the item in the cart
   When i click on "Proceed to checkout"
    And i fill the order form
    And i click on "Submit Order"
   Then i should be onto the order page
    And i should see "Created a new Order"