module AppApi
  module V1
    class Book < Grape::API
      version 'v1', using: :path
		resource :books do

		  desc '获取单词表列表数据 /app_api/books'
		  params do
			requires :user_id, type: Integer, desc: "用户id"
			optional :page, type: Integer, default: 1
			optional :per, type: Integer, default: 10
			optional :q, type: Hash do
			  optional :name_eq, type: String, desc: "单词表名称"
			end
		  end
		  get '' do
			books = ::Book.order("id DESC").ransack(params[:q]).result.page(params[:page]).per(params[:per])
			{status: true, data: books.map { |book|
			  {
				name: book.name,
				desc: book.desc,
				sum: book.words.count,
				master_sum: ::NewBook.where(user_id: params[:user_id]).joins(:new_word_books).("new_word_books.word_id in (?) and new_word_books.is_master", book.word_ids, true).uniq.count,
				book_id: book.id
			  }
			}}
		  end

		  namespace ':id' do
			desc '获取单词表详情 /app_api/books/id'
			params do
			  optional :q, type: Hash do
				# gem ransack可以生成 or查询   有两个写法的数据可以这样查 后续可以用sunspot的方式搜索起来更快
				optional :wordlist_eq_or_other_wordlist_eq, type: String, desc: "单词"
			  end
			end
			get '' do
			  @book = ::Book.find_by(id: params[:id])
			  # 关联查询 按照修改是否掌握的时间排序
			  words = @books.words.joins("LEFT JOIN new_word_books on new_word_books.word = words.id").order("new_word_books.updated_at DESC").ransack(params[:q]).result
			  {status: true, data: words.map{|word| {wordlist: [word.wordlist, word.other_wordlist], translate: word.translate, pronunciation: word.pronunciation, example_sentence: word.example_sentence, word_id: word.id}}}
			end

		  end
		end
	end
  end
end