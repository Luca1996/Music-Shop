# This script contains methods which can be used by all the controllers
# This is not to repeat the code in all controllers and make them DRY

module InstrumOwned
    def instrum_owned_by_user?(instrum)
        if instrum.product.user == current_user || current_user.admin?
            return true
        end
        false
    end
end