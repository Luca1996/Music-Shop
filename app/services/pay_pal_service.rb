class PayPalService
    def initialize(params)
        @order = params[:order]
    end



    ## PAYOUT SECTION

    def create_payout
        payout = PayPal::SDK::REST::Payout.new({
            :sender_batch_header => {
                :sender_batch_id => SecureRandom.hex(8),    #"#{@order.id}",    
                :email_subject => 'You have a Payout!'
            },
            :items => payout_items
        });
        payout
    end


    def payout_items
        items = []
        @order.line_items.each do |line_item|
            items << {
                recipient_type: 'EMAIL',
                amount: {
                    value: "#{line_item.price.round(2)}",
                    currency: 'EUR'
                },
                note: 'Thanks due your business',
                sender_item_id: '2014031400023',        #"#{line_item.id}",
                #Assuming user email is paypal email
                receiver: "#{line_item.product.user.email}"
            }
        end
        items
    end

    ####


    ## PAYMENT SECTION

    def create_payment
        payment = PayPal::SDK::REST::Payment.new({
            intent: "sale",
            payer: { payment_method: "paypal" },
            #order id saved in notes
            note_to_payer: "#{@order.id}",
            redirect_urls: { return_url: "http://localhost:3000/paypal/payment_success", cancel_url: "http://localhost:3000/paypal/payment_cancel" },
            transactions: [{ item_list: { items: payment_items },
                             amount: { total: "#{total.round(2)}",
                                       currency: "EUR"
                                     }
                            }]   
        })
        payment
    end

    def payment_items
        items = []
        @order.line_items.each do |line_item|
            items << { name: "#{line_item.product.title}",
                       price: "#{line_item.product.price}",
                       currency: "EUR",
                       quantity: line_item.quantity
                     }                     
        end
        items
    end

    def self.execute_payment(payment_id, payer_id)
        payment = PayPal::SDK::REST::Payment.find(payment_id)
        payment.execute(payer_id: payer_id)
        payment
    end

    ####


    def total
        prices = @order.line_items.map {|li| li.product.price}
        prices.inject(0){|l1,l2| l1 + l2}
    end

end