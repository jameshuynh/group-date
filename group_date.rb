# rubocop:disable AbcSize, MethodLength, ClassLength, BlockLength

require 'date'

class GroupDate
  def initialize(dates)
    @dates = dates.sort { |x, y| x <=> y }
  end

  def call
    return '' if dates.length.zero?
    return process_one_date if dates.length == 1
    return process_two_dates if dates.length == 2

    process_more_than_two_dates
  end

  def process_one_date
    dates[0].strftime('%d %b %Y')
  end

  def process_two_dates
    if dates[0].year == dates[1].year
      [
        [
          dates[0].strftime('%d %b'),
          dates[1].strftime('%d %b')
        ].join(' and '),
        dates[0].strftime('%Y')
      ].join(' ')
    else
      [
        dates[0].strftime('%d %b %Y'),
        dates[1].strftime('%d %b %Y')
      ].join(' and ')
    end
  end

  def process_more_than_two_dates
    year_groups = group_dates_into_year_group(dates)
    year_hash = {}
    year_groups.each do |year_group|
      month_groups = group_dates_into_month_group(year_group)

      month_hash = {}
      month_groups.each do |month_group|
        consecutive_groups = group_consecutive_dates(month_group)
        month_hash[month_group[0].strftime('%b')] = consecutive_groups
      end

      year_hash[year_group[0].strftime('%Y')] = month_hash
    end

    result = []
    year_hash.each_key do |year_key|
      sub_result = []
      year_hash[year_key].each_key do |month_key|
        month_group = year_hash[year_key][month_key]
        month_group.each_with_index do |consecutive_group, index|
          sub_result << if consecutive_group.length == 1
                          if month_group[index + 1] &&
                              consecutive_group[0].strftime('%m') == \
                                  month_group[index + 1][0].strftime('%m')
                            consecutive_group[0].strftime('%d')
                          else
                            consecutive_group[0].strftime('%d %b')
                          end
                        else
                          [
                            [
                              consecutive_group[0].strftime('%d'),
                              consecutive_group[-1].strftime('%d')
                            ].join(' to '),
                            consecutive_group[0].strftime('%b')
                          ].join(' ')
                        end
        end
      end
      result << [
        [
          sub_result[0..-2].compact.join(', '),
          sub_result[-1]
        ].compact.reject { |x| x == '' }.join(' and '),
        year_key
      ].join(' ')
    end

    final_result = [
      result[0..-2].compact.join(', '),
      result[-1]
    ].compact.reject { |x| x == '' }.join(' and ')

    and_params = final_result.split(' and ')
    if and_params.length == 1
      final_result
    else
      [
        and_params[0..-2].compact.join(', '),
        and_params[-1]
      ].compact.reject { |x| x == '' }.join(' and ')
    end
  end

  def group_consecutive_dates(list_of_dates)
    groups = []
    current_group = [list_of_dates[0]]
    groups << current_group
    (0..(list_of_dates.length - 2)).each do |i|
      if list_of_dates[i] + 1 == list_of_dates[i + 1]
        current_group << list_of_dates[i + 1]
      else
        current_group = [list_of_dates[i + 1]]
        groups << current_group
      end
    end

    groups
  end

  def group_dates_into_year_group(list_of_dates)
    groups = []
    current_group = [list_of_dates[0]]
    groups << current_group

    (0..(list_of_dates.length - 2)).each do |i|
      if list_of_dates[i].strftime('%Y') == list_of_dates[i + 1].strftime('%Y')
        current_group << list_of_dates[i + 1]
      else
        current_group = [list_of_dates[i + 1]]
        groups << current_group
      end
    end

    groups
  end

  def group_dates_into_month_group(list_of_dates)
    groups = []
    current_group = [list_of_dates[0]]
    groups << current_group

    (0..(list_of_dates.length - 2)).each do |i|
      if list_of_dates[i].strftime('%b') == list_of_dates[i + 1].strftime('%b')
        current_group << list_of_dates[i + 1]
      else
        current_group = [list_of_dates[i + 1]]
        groups << current_group
      end
    end

    groups
  end

  private

  attr_accessor :dates
end

# rubocop:enable all
