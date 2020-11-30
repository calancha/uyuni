# Copyright (c) 2020 SUSE LLC
# Licensed under the terms of the MIT license.
#
# Not idempotent: after this test, the sle_client
# is upgraded to SLE 15 SP3; run this test after all
# sle_client tests.

Feature: Service pack migration

  Scenario: Migrate this "sle_client"
    Given I am on the Systems overview page of this "sle_client"
    When I follow "Software" in the content area
    And I follow "SP Migration" in the content area
    And I should see a "Service Pack Migration - Target" text
    And I click on "Select Channels"
    And I wait until I see "SUSE Linux Enterprise Server 15 SP2 x86_64" text
    And I click on "Schedule Migration"
    And I should see a "Service Pack Migration - Confirm" text
    And I click on "Confirm"
    Then I should see a "This system is scheduled to be migrated to" text

  Scenario: Check the migration status
    Given I am on the Systems overview page of this "sle_client"
    When I follow "Events"
    And I follow "History"
    And I wait at most 600 seconds until event "Package List Refresh scheduled by admin" is completed

  Scenario: Check the migration is successful
    Given I am on the Systems overview page of this "sle_client"
    When I follow "Details" in the content area
    Then I should see a "SUSE Linux Enterprise Server 15 SP2" text
