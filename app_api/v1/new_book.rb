module AppApi
  module V1
    class NewBook < Grape::API
      version 'v1', using: :path
		resource :new_books do

		  desc '获取生词表列表数据 /app_api/new_books'
		  params do
			requires :user_id, type: Integer, desc: "用户id"
			optional :page, type: Integer, default: 1
			optional :per, type: Integer, default: 10
			optional :q, type: Hash do
			  optional :word_wordlist_eq_or_word, type: String, desc: "单词表名称"
			end
		  end
		  get '' do
			new_book = ::NewBook.find_by(user_id: params[:user_id])
			words = new_books.words.order("id DESC").ransack(params[:q]).result.page(params[:page]).per(params[:per])
			{status: true, data:
			  {
				name: new_book.name,
				desc: new_book.desc,
				sum: new_book.words.count,
				master_sum: new_book.words.where(is_master: true).count,
				new_book_id: new_book.id,
				word_list: words.map{ |word| { 
				  wordlist: [word.wordlist, word.other_wordlist], 
				  translate: word.translate, 
				  pronunciation: word.pronunciation, 
				  example_sentence: word.example_sentence,
				  word_id: word.id}
				}
			  }
			}
		  end

		  desc "新增生词  /app_api/new_books/create_new_word"
		  params do
			requires :user_id, type: Integer, desc: "用户id"
			requires :new_book_id, type: Integer, desc: "生词表id"
			requires :word_id, type: Integer, desc: "单词id"
		  end
		  post "create_new_word" do
			new_book = ::NewBook.find_or_initialize_by(new_book_id: params[:new_book_id], user_id: params[:user_id])
			new_book.save if new_book.new_record?
			new_word_book = ::NewWordBook.new(word_id: params[:word_id], new_book_id: new_book.id)
			if new_word_book.save
			  {status: true, data: {msg: '保存到生词表成功'}}
			else
			  {status: false, data: {msg: '保存到生词表失败'}}
			end
		  end

		  desc "是否掌握生词  /app_api/new_books/is_master"
		  params do
			requires :user_id, type: Integer, desc: "用户id"
			requires :new_book_id, type: Integer, desc: "生词表id"
			requires :word_id, type: Integer, desc: "单词id"
			requires :is_master, type: Boolean, desc: "是否掌握"
		  end
		  post "is_master" do
			new_book = ::NewBook.find_by(new_book_id: params[:new_book_id], user_id: params[:user_id])
			return {status: false, data: {msg: "请创建先单词表"}} if new_book.blank?
			new_word_book = NewWordBook.find_by(word_id: params[:word_id], new_book_id: new_book.id)
			return {status: false, data: {msg: "未添加该单词"}} if new_word_book.blank? 
			if new_word_book.update(is_master: params[:is_master])
			  {status: true, data: {msg: '修改成功'}}
			else
			  {status: false, data: {msg: '修改失败'}}
			end
		  end

		end
	end
  end
end