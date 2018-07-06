Feature: Order checkout

    As a User 
    I want to be notified with a message when i complete an order 
    So that i can verify the success of the order


Background: Log in and add an item in the cart
 
  Given i am logged in as an User
    And i have added an item in the cart

Scenario: Order checkout and notification for success
 
   Then i should be into the current cart page
    And i should see the item in the cart
   When i click on "Proceed to checkout"
    And i fill the order form with valid values
    And i click on "Submit Order"
   Then i should be onto the order page
    And i should see "Created a new Order"
  
Scenario: Order checkout with invalid tel_number
  
   Then i should be into the current cart page
    And i should see the item in the cart
   When i click on "Proceed to checkout"
    And i fill the order form with an invalid tel_number
   Then i press on "Submit Order" and raise an error

Scenario: Order checkout with void address field
  ## Note: address field is a required field so i'll get a validation error

  Then i should be into the current cart page
   And i should see the item in the cart
  When i click on "Proceed to checkout"
   And i fill the order form without field address
  Then i press on "Submit Order" and raise an error