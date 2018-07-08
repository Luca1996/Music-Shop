Feature: An User can see the lower price found on Walmart Database 

   As a User
   I want to see the lower price for an item in my list on Walmart
   So that i can sell it at a lower price

Background: Start from the home page as logged user

    Given that i am on Music-Shop homepage
    And i am logged in as an User


Scenario: Try to see the price of an instrument that isn't in Walmart database

    And i have an item with title "NewPiano1" which is "not present" in Walmart database for sale
    Then i should see "My Activities"
    When i click on "My Activities"
    Then i should be on the activities index page
    Then i search the item with title "NewPiano1" and click on "Modify" 
    And i should be into the edit piano page
    Then i should not see "Lower price on Walmart"

Scenario: Try to see the price of an instrument in Walmart database

    And i have an item with title "NewPiano2" which is "present" in Walmart database for sale
    Then i should see "My Activities"
    When i click on "My Activities"
    Then i should be on the activities index page
    Then i search the item with title "NewPiano2" and click on "Modify"
    And i should be into the edit piano page
    Then i should see "Lower price on Walmart"