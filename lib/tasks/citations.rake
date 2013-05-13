# class to represent spreadsheets that can be parsed
# and inserted into db
# offsets are the rows to start and end on
# years represent the number of years of data we have
# click_types are if the user downloaded HTML or PDF version of articles

class MyCite
  def initialize fname
    @fname = fname
  end

  def fname
    @fname
  end

  def parse_citations
    Spreadsheet.client_encoding = 'UTF-8'
    xl_file = self.fname
    book = Spreadsheet.open xl_file 
    sheet = book.worksheet 0

    author = 'AU'
    author_expanded = 'AF'
    journal = 'SO'
    cited_ref = 'CR'
    number_ref = 'NR'
    end_recored = 'ER'
    end_file = 'EF'
    puts "Begin Parse for #{self.fname}"

    cite_count = 0
    cite_on = false

    a = nil
    #c = nil
    article_count = 0

    # begin looping over each row in the spreadsheet
    sheet.each_with_index do |row, index|
      if row[0].blank?
        next 
      end

      cell = row[0].to_s
      if cell.start_with?('TI')
        a = Article.new
        a.title = cell.split('TI').last
      elsif cell.start_with?('SO')
        # source article
        a.journal = cell.split('SO').last
        a.reference_type = "source"
        a.save
        article_count += 1
      elsif cell.start_with?('CR')
        # turn on citation counter and get citation
        cite_on = true
        cite_count += 1
        
        c = Article.new
        c.author = cell.split('CR').last
        c.reference_type = "citation"
        c.year = row[1]
        c.journal = row[2]
        c.save
        a.save
        citation = Citation.new
        citation.cite_id = c.id
        citation.article_id = a.id
        citation.save
      elsif cell.start_with?('NR')
        # get total number of citations for this article and verify
        # if we are at num count then cut it off
        cite_on = false
        num_records = cell.split('NR').last
        # we should have as many citations as the value of NR (num records)
        if num_records.to_i != cite_count
          puts num_records.to_i
          puts "WTF!!"
          break
        end
      elsif cite_on
        # we are in the citation listing, get them 
        cite_count += 1
        #puts "#{row[0]}\t\t#{row[1].floor}\t\t#{row[2]}"
        c = Article.new
        c.author = cell 
        c.reference_type = "citation"
        c.year = row[1]
        c.journal = row[2]
        c.save
        a.save
        citation = Citation.new
        citation.cite_id = c.id
        citation.article_id = a.id
        citation.save
      elsif cell.start_with?('ER')
        # end of record, reset everything 
        puts "Count"
        puts cite_count
        cite_count = 0
        cite_on = false
        a = nil
        #c = nil
      end
#      if index == 114
#        break
#      end
    end
    puts "Citation Count: #{cite_count}"
    puts "Articles: #{article_count}"
    puts "End Parse for #{self.fname}" 
  end
  
end

namespace :citation do
  desc 'do something'
  task :wacky => :environment do
    # set up the spreadsheets
    ss = MyCite.new("savedrecs.xls")
    ss.parse_citations
  end
end
