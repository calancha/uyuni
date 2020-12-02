# Copyright (c) 2020 SUSE LLC
# Licensed under the terms of the MIT license.
#
# Not idempotent: after this test, the sle_minion
# is upgraded to SLE 15 SP3; run this test after all
# sle_minion tests.

Feature: Service pack migration for minion

  Scenario: Delete the normal minion for service pack migration
    Given I am on the Systems overview page of this "sle_minion"
    When I follow "Delete System"
    Then I should see a "Confirm System Profile Deletion" text
    When I click on "Delete Profile"
    And I wait until I see "has been deleted" text
    Then "sle_minion" should not be registered

  Scenario: Register this minion for service pack migration
    Given I am authorized as "admin" with password "admin"
    When I bootstrap minion client "sle_minion" using bootstrap script with activation key "1-SUSE-SP-MIGRATION-x86_64" from the server
    And I wait at most 10 seconds until Salt master sees "sle_minion" as "unaccepted"
    And I accept "sle_minion" key in the Salt master
    And I should see "sle_minion" via spacecmd
    And I am on the System Overview page
    And I wait until I see the name of "sle_minion", refreshing the page
    And I wait until onboarding is completed for "sle_minion"

  Scenario: Migrate this normal minion to SLE 15 SP2
    Given I am on the Systems overview page of this "sle_minion"
    When I follow "Software" in the content area
    And I follow "SP Migration" in the content area
    And I wait until I see "Target Products:" text, refreshing the page
    And I click on "Select Channels"
    And I wait until I see "SUSE Linux Enterprise Server 15 SP2 x86_64" text
    And I click on "Schedule Migration"
    And I should see a "Service Pack Migration - Confirm" text
    And I click on "Confirm"
    Then I should see a "This system is scheduled to be migrated to" text

  Scenario: Check the migration status for this minion
    Given I am on the Systems overview page of this "sle_minion"
    When I follow "Events"
    And I follow "History"
    And I wait at most 600 seconds until event "Service Pack Migration scheduled by admin" is completed

  Scenario: Check the migration is successful for this minion
    Given I am on the Systems overview page of this "sle_minion"
    When I follow "Details" in the content area
    Then I should see a "SUSE Linux Enterprise Server 15 SP2" text

  Scenario: Cleanup: delete the migrated normal minion
    Given I am on the Systems overview page of this "sle_minion"
    When I follow "Delete System"
    Then I should see a "Confirm System Profile Deletion" text
    When I click on "Delete Profile"
    And I wait until I see "has been deleted" text
    Then "sle_minion" should not be registered

  Scenario: Cleanup: hosts file of normal minion via SSH tunnel
    Given I am on the Systems page
    And I run "sed -i '/127.0.1.1/d' /etc/hosts" on "sle_minion"
    And I run "rm /srv/www/htdocs/pub/bootstrap/bootstrap.sh" on "server"
    And I remove server hostname from hosts file on "sle_minion"

  Scenario: Cleanup: register a normal minion after service pack migration
    When I bootstrap minion client "sle_minion" using bootstrap script with activation key "1-SUSE-PKG-x86_64" from the server
    And I wait at most 10 seconds until Salt master sees "sle_minion" as "unaccepted"
    And I accept "sle_minion" key in the Salt master
    Then I should see "sle_minion" via spacecmd
