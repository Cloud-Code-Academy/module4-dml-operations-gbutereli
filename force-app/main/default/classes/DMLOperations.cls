/**
 * The DMLOperations class serves as a deep dive into Data Manipulation Language (DML) in Apex.
 * It covers fundamental DML operations such as insert, update, upsert, and delete.
 *
 * This class introduces developers to the concept of manipulating Salesforce records in Apex.
 * It discusses how to use DML operations to create, update, and delete records.
 * This class uses standard Salesforce objects like Account, Contact, and Opportunity for demonstration.
 *
 * Topics covered in this class include:
 * - Understanding how to use insert DML operation to create records in Salesforce.
 * - Understanding how to use update and upsert DML operations to update existing records in Salesforce.
 * - Understanding how to use delete DML operation to remove records from Salesforce.
 *
 * Users of this class can expect to gain a strong understanding of DML operations in Apex and
 * be prepared for more advanced topics in Salesforce development.
 *
 * The methods within this class serve as practical examples of different DML operations,
 * allowing developers to learn through practice and examples.
 *
 * @author Your Name
 */


public with sharing class DMLOperations {

    /**
     * Question 1
     * Create a new Account object and inserts it into the database.
     * The Account will have a random name for uniqueness.
     * @return The Id of the newly created Account.
     */
    public static Id insertNewAccount() {
        // Create a new Account instance
        Account acc = new Account();

        // Set some fields on the Account
        acc.Name = 'Rabook'; 
        acc.Description = 'Test Account';
        acc.NumberOfEmployees = 50;

        // Insert the Account into the database
        insert acc;

        // Return the Id of the newly created Account
        return acc.Id;
    }

    /**
     * Question 2
     * Create a new Account with the specified name and industry provided.
     * @param name The name of the account to be created.
     * @param industry The industry of the account to be created.
     */
    public static void createAccount(String name, String industry) {
        // Create a new Account and set the fields inline
        Account acc = new Account(Name = name, Industry= industry);

        // Insert the Account
        insert acc;

        
    }

    
    /**
     * Question 3
     * Create a new Contact and link it to the Account id provided then inserts it into the database.
     * @param accountId The Id of the Account to link the Contact to.
     * @return The Id of the newly created Contact.
     */
    public static Id insertNewContact(Id accountId) {
        // Create a new Contact instance
        Contact cont = new Contact();

        // Set some fields on the Contact
        // Set the AccountId field to the given accountId
        cont.AccountId = accountId;
        cont.FirstName = 'Gaël';
        cont.LastName = 'Butereli';
        cont.Title = 'Sir';


        // Insert the Contact into the database
        insert cont;

        // Return the Id of the newly created Contact
        return cont.Id;
    }

    /**
     * Question 4
     * Update the last name of a Contact in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param contactId The Id of the Contact to update.
     * @param newLastName The new last name for the Contact.
     */
    public static void updateContactLastName(Id contactId, String newLastName) {
        // Retrieve the Contact from the database
        // [SELECT Id FROM Contact WHERE Id = :contactId]
        Contact cont = [SELECT Id FROM Contact WHERE Id = :contactId];

        // Update the Contact's last name
        cont.LastName = newLastName;

        // Update the Contact in the database
        update cont;
    }

    /**
     * Question 5
     * Update the stage of an Opportunity in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param oppId The Id of the Opportunity to update.
     * @param newStage The new stage for the Opportunity.
     */
    public static void updateOpportunityStage(Id oppId, String newStage) {
        // Retrieve the Opportunity from the database
        // [SELECT Id FROM Opportunity WHERE Id = :oppId]
        Opportunity oppty = [SELECT Id FROM Opportunity WHERE Id = :oppId];
        
        // Update the Opportunity's stage
        oppty.StageName = newStage;

        // Update the Opportunity in the database
        update oppty;
    }

    /**
     * Question 6
     * Update the Account's Name and Industry given an Account Id.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param accountId The Id of the account to be updated.
     * @param newName The new name for the account.
     * @param newIndustry The new industry for the account.
     */
    public static void updateAccountFields(Id accountId, String newName, String newIndustry) {
        // Query the account
        // [SELECT Id FROM Account WHERE Id = :accountId]
        Account acc = [SELECT Id FROM Account WHERE Id = :accountId];

        // Update the Account with the given Id with the new name and industry
        acc.Name = newName;
        acc.Industry = newIndustry;

        update acc;
    }


    /**
     * Question 7
     * Create or updates an Opportunities
     * The Opportunity's Stage is set to Qualification.
     * The Opportunity's Close Date is set to 3 months from today.
     * The Opportunity's Amount is set to 50000.
     * @param list of Opportunities to be changed then upserted.
     */
    public static void upsertOpportunityList(List<Opportunity> opportunities) {
        // Iterate over the opportunities
            // Set the Opportunity's Stage to Qualification
            // Set the Opportunity's Close Date to 3 months from today
            // Set the Opportunity's Amount to 50000

        List<Opportunity> opptyList = new List<Opportunity>();

        for(Opportunity opp : opportunities){
            opp.StageName = 'Qualification';
            opp.CloseDate = Date.today().addMonths(3);
            opp.Amount = 50000;
            opptyList.add(opp);

        }

        upsert opptyList;
       

        // Upsert the Opportunity
    }

    /**
     * Question 8
     * Insert or updates opportunities from list of names.
     * Associate the Opportunities with account that has the name accountName.
     * There should be an Opportunity for each name provided in the list.
     * @param accountName The name of the Account.
     * @param oppNames The list of Opportunity names.
     */
    public static void upsertOpportunities(String accountName, List<String> oppNames) {
        // Loop through each Opportunity name
            // Create an Opportunity with the given name
            // Add the Opportunity to the list
        List<Account> accList = [SELECT Id FROM ACCOUNT WHERE Name = :accountName LIMIT 1];

        Id acc;

        if(accList.isEmpty()){
            Account newAcc = new Account(Name = accountName);
            insert newAcc;
            acc = newAcc.Id;
        } else {
            acc = accList[0].Id;
        }

        List<Opportunity> opptyList = new List<Opportunity>();

        for(String name : oppNames){

            List<Opportunity> existingOppty = [SELECT Id, Name, AccountId FROM Opportunity WHERE AccountId = :acc AND Name = :oppNames LIMIT 1];
            Opportunity oppty = new Opportunity();

            if(existingOppty.isEmpty()){
            oppty.AccountId = acc;
            oppty.Name = name;
            oppty.CloseDate = Date.today().addDays(30);
            oppty.StageName = 'Qualification';
            opptyList.add(oppty);

          } else {

            oppty = existingOppty[0];

          }
        } 

        upsert opptyList;
       
    }
    
    /**
     * Question 9
	 * Upserts an Account with the specified name.
	 * If an Account with the given name already exists, update the description to "Updated Account".
	 * If no such Account exists, it creates a new one and sets the description to "New Account".
	 * @param accountName The name of the Account to be upserted.
	 * @return The Account that was upserted.
	 */
	public static Account upsertAccount(String accountName) {
		// Query for the Account
		List<Account> accounts = [SELECT Id FROM Account WHERE Name = :accountName LIMIT 1];

		// if the Account exists, update the description
        // otherwise, create a new Account and set the description
        Account acc;
        if (!accounts.isEmpty()) {
            acc = accounts[0];
            acc.Description = 'Updated Account';

        } else {
            acc = new Account(Name = accountName, Description = 'New Account');
        }

		// Upsert the Account
		upsert acc;

        return acc;
	}

    /**
     * Question 10
	 * Upserts accounts and links contacts to them based on the contact's last name and account name.
	 * Create or use existing account with contact last name. (Hint: use previous upsertAccount method - this may cause bad practices but for learning purposes it's okay.)
	 * Contacts are then linked to these accounts based on a full last name match.
     * Example Contact Last Name = Doe Link to Account Name = Doe 
     * Example Contact Last Name = Jane Link to Account Name = Jane
	 * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
	 */
	public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {
		// Loop through each Contact
        // Extract the Account Name from Contact's LastName

        List<String> accNameList = new List<String>();

        for(Contact contName : contactsToUpsert){
            accNameList.add(contName.LastName);
        }

		// Get the account based on the name or create one if it doesn't exist
        Map<String,Account> accountMap = new Map<String,Account>();

        List<Account> existingAccount = [SELECT Id, Name FROM ACCOUNT WHERE Name IN :accNameList LIMIT 1];

        for(Account acc : existingAccount ){
            accountMap.put(acc.Name, acc);
        }

        for(String accName : accNameList){
            if(!accountMap.containsKey(accName)){
                Account newAcc = new Account(Name = accName);
                accountMap.put(accName, newAcc);
            }

        upsert accountMap.values();
    
        }

		// Link the Contact to its Account using the Account Id
        for(Contact cont : contactsToUpsert){
            Account acc = accountMap.get(cont.LastName);
            cont.AccountId = acc.Id;
        }

		// Upsert the Contacts
        upsert contactsToUpsert;
	}

    /**
     * Question 11
     * Insert a list of Leads and then deletes them.
     * @param leadNames The list of Lead names to be inserted.
     */
    public static void insertAndDeleteLeads(List<String> leadNames) {
        // Loop through each Lead name
        List<Lead> leadList = new List<Lead>();

        for(String nameLeads : leadNames){
            Lead lead = new Lead(LastName = nameLeads, Status = 'Open - Not Contacted', Company = 'Rabook');
            leadList.add(lead);
        }

        // Insert the Leads
        insert leadList;

        // Delete the Leads
        delete leadList;
    }


    /**
     * Question 12
     * Dynamically create the number of cases and relate it to the accountId, then deletes them.
     * @param accountId The account for which the cases will be created and then deleted.
     * @param numOfCases The number of cases to create.
     */
    public static void createAndDeleteCases(String accountId, Integer numOfCases) {
        // Insert the cases
        List<Case> caseList = new List<Case>();

        for(Integer i=1; i<numOfCases; i++){
            Case caseToCreate = new Case(accountId = accountId, Status = 'New', Origin = 'Web' );
            caseList.add(caseToCreate);
        }
        insert caseList;

        // Delete the cases
        delete caseList;
    }
}