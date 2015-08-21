# Put everything in order except for the actual test.
# Try running it., by commenting out the testing. Make sure everything else works


# Read in the schools.csv
# Either you can read it line by line (.foreach) or all together.

require 'csv' 

merge = []

schools_not_found = []

repairs_2010 = CSV.read("school_repairs_2010.csv", headers: true)

repairs_2011 = CSV.read("school_repairs_2011.csv", headers: true)

repairs_2012 = CSV.read("school_repairs_2012.csv", headers: true)

repairs_2013 = CSV.read("school_repairs_2013.csv", headers: true)

repairs_2014 = CSV.read("school_repairs_2014.csv", headers: true)

school_repairs_found = 0
school_repairs_not_found = 0

def clean_school_name(school_name)
	if !school_name.nil?
		school_name.gsub(/^.*მუნიციპალიტეტის სოფელ\s/, "").gsub(/^.*მუნიციპალიტეტის დაბა\s/, "").gsub(/^.+-\s/, '').gsub(/\s{2,}/, ' ').strip
	end
end

def clean_repaired_name(repaired_name)
	if !repaired_name.nil?
		repaired_name.gsub('#','№').gsub(/\(.+\)/, '').gsub(/^.*\.\s/, "").gsub(/^.*დ.\s/, "").gsub(/^.*მუნიციპალიტეტის სოფელ\s/, "").gsub(/^.*მუნიციპალიტეტის დაბა\s/, "").gsub(/\s{2,}/, ' ').strip
	end
end

def record_repaired_schools(school_matches, merge_school, repairs_found)
	if school_matches.length !=0 
		repairs_found +=1
		if school_matches.length == 1
			merge_school << school_matches[0][3] 
			merge_school << school_matches[0].to_a.last.gsub(',', '').to_f
		else 
			type = []
			cost = 0

			school_matches.each do |match|
				type << match[3]
				puts "--------> #{match.to_a}"
				cost += match.to_a.last.gsub(',', '').to_f
			end 
			merge_school << type
			merge_school << cost
		end
		merge_school << school_matches.length
	else
		merge_school << nil
		merge_school << nil
		merge_school << nil
	end
end	
	
#.gsub(/^.*სოფ.\s/, "")

CSV.foreach('schools.csv', :headers => true) do |school| 
	puts ""
	puts "--------> #{school}"

	if $. % 100 == 0
		puts $.
	end

	merge_school = [school[2], school[0], school[1], school[5], school[3], school[4]]
	#This is all the data from school.csv CHECK THE ORDER AND USE THEM AS HEADERS!

	repairs_found = 0


	#Calculate the ratio % by testing
	if !school[4].nil? && school[4]!=0
		
		merge_school << (school[3].to_f/school[4].to_f).round(2)
	else 
		merge_school << nil
	end

	#When looking at the file school_repairs
	#Go through the repairs for each year

	#Here I am looking at all the data in all the repaire-files
	
	school_2010 = repairs_2010.select{|repairs_school_name| !repairs_school_name[2].nil? && clean_school_name(school[2]).include?(clean_repaired_name(repairs_school_name[2]))}

	record_repaired_schools(school_2010, merge_school, repairs_found)	

	#	.gsub(/^.+-\s/', '').gsub('სსიპ', '').gsub('შპს', '').gsub('ა(ა)იპ', '').gsub('სპს', '').gsub('სიპ', ' ').gsub('სს', ' ')
	
	#school_2010 = repairs_2010.select{|repairs_school_name| school[2].include?(repairs_school_name[2].gsub('#','№').gsub(/\(.+\)/, '').gsub(/\s{2,}/, ' ')}
	

	school_2011 = repairs_2011.select{|repairs_school_name| !repairs_school_name[2].nil? && clean_school_name(school[2]).include?(clean_repaired_name(repairs_school_name[2]))}
	
	record_repaired_schools(school_2011, merge_school, repairs_found)	



	school_2012 = repairs_2012.select{|repairs_school_name| !repairs_school_name[2].nil? && clean_school_name(school[2]).include?(clean_repaired_name(repairs_school_name[2]))}

	record_repaired_schools(school_2012, merge_school, repairs_found)	



	school_2013 = repairs_2013.select{|repairs_school_name| !repairs_school_name[2].nil? && clean_school_name(school[2]).include?(clean_repaired_name(repairs_school_name[2]))}
 	
 	record_repaired_schools(school_2013, merge_school, repairs_found)	



	school_2014 = repairs_2013.select{|repairs_school_name| !repairs_school_name[2].nil? && clean_school_name(school[2]).include?(clean_repaired_name(repairs_school_name[2]))}

 	record_repaired_schools(school_2014, merge_school, repairs_found)	

	# Taking all the rows from merge_school and merge it.

	if repairs_found == 0
		school_repairs_not_found +=1
		puts "Not found for row #{$.}, #{school[2]}."

		schools_not_found << school[2]
	
	else
		school_repairs_found +=1
	end

	merge << merge_school
 end


puts""
puts "#{school_repairs_found} have been found in the files regarding repaired school during 2010-2014."
puts ""
puts "#{school_repairs_not_found} have not been found."
puts ""

	# Save merge to CSV
	
	# Write a new csv-file and add a row of headers. (Look up: How to write a new csv?)


 CSV.open("schools_counts_reconstruction_merge.csv", 'wb' ) do |csv|
 	csv << ["School name", "Region", "District", "Adress", "Number students", "Number teachers", "Student teacher ratio", "2010 - Type", "2010 Cost", "2011 Type", "2011 Cost", "2012 Type", "2012 Cost", "2013 Type", "2013 Cost", "2014 Type", "2014 Cost"]	

	merge.each do |school|
		csv << school
	end
end 


CSV.open("schools_not_found.csv",'wb') do |csv|
	csv << ["School name"]

	schools_not_found.each do |names|
		csv << [names]
	end
end


# I am writing the names from School.csv and going through repairs-files to match?
# How can I clean the repairs to find them in School.csv??


# Think of how you can compare the files with each other. What can you do with these strings to see if they are equal to one another...
# Change all the # into No
# Things to test:
#How many schools have been renovated for more than 30 000 lari?
#How many students did the schools with a Contractual Sum over 10 000 lari have?
#How many students did the schools with a Contractual Sum less than 10 000 lari have?
#Which school had the lowest renovation costs? How many students does that school have?
#Which school had the highest renovation costs? How many students does that school have?

