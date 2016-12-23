require "sinatra"
require "sinatra/activerecord"
require "sinatra/reloader"
require "active_record"
require "pry"
require "date"
require_relative "models/user"
require_relative "models/box"
require_relative "models/transaction"
require_relative "models/loan"

enable :"sessions"

helpers do
  def logged_in?
    !!current_user
  end

  def current_user
    User.find_by(id: session[:user_id])
  end
end

get "/" do
  if logged_in?
    redirect to "/user/#{session[:user_id]}"
  else
    erb :index
  end
end

post "/" do
  if params[:action] == "signup"
    redirect to "/user/new"
  elsif params[:action] == "login"
    redirect to "/session/new"
  end
end

# user log in page
get "/session/new" do
  if logged_in?
    redirect to "/user/#{session[:user_id]}"
  else
    erb :session_new
  end
end

# log in
post "/session" do
  user = User.find_by(email: params[:email])
  if user and user.authenticate(params[:password])
    session[:user_id] = user.id
    if user.user_type == "admin"
      redirect to "/user/admin"
    else
      redirect to "/user/#{user.id}"
    end
  else
    erb :session_new
  end
end

delete "/session" do
  session[:user_id] = nil
  redirect to "session/new"
end

# user sign up
get "/user/new" do
  erb :user_new
end

# save user into db
post "/user" do
  @user = User.new({
    first_name: params[:first_name],
    last_name: params[:last_name],
    email: params[:email],
    phone_number: params[:phone_number],
    address: params[:address],
    user_type: "standard",
    user_number: params[:id_number],
    password: params[:password],
    password_confirmation: params[:password_confirmation]
    })
    if @user.save
      session[:user_id] = @user.id
      redirect to "/user/#{@user.id}"
    else
      @error_message = @user.errors.messages
      erb :user_new
    end
end

# display users from admin page
get "/user/admin" do
  @admin = User.find_by(id: session[:user_id])
  #@users = User.where.not(id: session[:user_id])
  @users = User.all
  erb :user_admin
end

# display single user from admin view
get "/user/admin/:id" do
  @user = User.find_by(id: params[:id])
  @loans = @user.loans # display user's loans
  erb :single_user_admin
end

# display form to edit an user from admin view
get "/user/admin/edit/:id" do
  @user = User.find_by(id: params[:id])
  erb :single_user_admin_edit
end

# edit the user's db record
post "/user/admin/edit/:id" do
  @user = User.find_by(id: params[:id])
  @user.first_name = params[:first_name]
  @user.last_name = params[:last_name]
  @user.email = params[:email]
  @user.phone_number = params[:phone_number]
  @user.address = params[:address]
  @user.user_number = params[:user_number]
  if @user.save
    redirect to "/user/admin"
  end
end

# delete single user
delete "/user/admin/:id" do
  @user = User.find_by(id: params[:id])
  if @user.user_type != "admin"
    if @user.destroy
      redirect to "/user/admin"
    end
  else
    @message = "User admin cannot be deleted"
    erb :single_user_admin
  end
end

# display single user page
get "/user/:id" do
  # validate the user id session
  if params[:id] != session[:user_id].to_s
    redirect to "not_found"
  else
    @user = User.find_by(id: params[:id])
    if @user.user_type == "admin"
      redirect to "/user/admin"
    end
    @loans = @user.loans # display user's loans

    erb :user
  end
end

# link to request a new loan, display loan form
get "/loan/new" do
  erb :loan_new
end

# after filled the loan form, save it into db
post "/loan/new" do
  @loan = Loan.new({
    user_id: session[:user_id],
    amount: params[:amount],
    term: params[:term],
    balance: params[:amount],
    amount_paid: 0,
    approved: false,
    description: params[:description]
    })
    if @loan.save
      redirect to "/user/#{session[:user_id]}"
    end
end

# display a single loan with all its transactions
get "/loan/:id" do
  @loan = Loan.find_by(id: params[:id])
  @fee_amount = 0
  if @loan.approved?
    @fee_amount = calculate_fee @loan.balance, @loan.term, @loan.interest
  end
  @transactions = @loan.transactions # display all the loan's transactions
  erb :loan
end

# make payment
post "/loan/:id" do
  @loan = Loan.find_by(id: params[:id])
  amount_paid = params[:amount_paid].to_f
  loan_balance = @loan.balance - amount_paid
  # create transaction
  @transaction = Transaction.new({
    loan_id: @loan.id,
    user_id: @loan.user_id,
    transaction_date: Date.today,
    transaction_type: params[:transaction_type],
    amount: params[:amount_paid],
    loan_balance: loan_balance,
    description: params[:description]
    })
    if @transaction.save
      # update loan
      @loan.balance = loan_balance
      loan_amount_paid = @loan.amount_paid + amount_paid
      @loan.amount_paid = loan_amount_paid
      if @loan.save
        redirect to "/user/#{@loan.user_id}"
      end
    end
end

# display a single loan from admin view
get "/admin_user_loan/:id" do
  #..
  @loan = Loan.find_by(id: params[:id])
  erb :loan_user_admin
end

# update loan when it is approved
post "/admin_user_loan/:id" do
  @loan = Loan.find_by(id: params[:id])
  @loan.approved = true
  @loan.interest = params[:interest]
  if @loan.save
    redirect to "/user/admin"
  end
end

# delete a loan when it is rejected
delete "/admin_user_loan/:id" do
  @loan = Loan.find_by(id: params[:id])
  # if the loan is already approved, it cannot be deleted
  if @loan.approved == false
    if @loan.destroy
      redirect to "/user/admin"
    end
  else
    redirect to "/admin_user_loan/#{@loan.id}"
  end
end

not_found do
  erb :notfound
end


def calculate_fee (loan_balance, loan_term, interest)
  (loan_balance / loan_term) + (loan_balance * (interest/100))
end
