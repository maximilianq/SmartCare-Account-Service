from app import AccountService

def main():
    account_service: AccountService = AccountService()
    account_service.start()

if __name__ == '__main__':
    main()