# rubocop:disable ClassLength
require './group_date'

require 'minitest/autorun'

class GroupDateTest < MiniTest::Unit::TestCase
  def test_dummy
    assert true
  end

  def test_single_date
    group_date = GroupDate.new([Date.parse('01-01-2019')])
    assert_equal group_date.call, '01 Jan 2019'
  end

  def test_two_dates_on_same_year
    group_date = GroupDate.new(
      [
        Date.parse('01-01-2019'),
        Date.parse('02-01-2019')
      ]
    )
    assert_equal group_date.call, '01 Jan and 02 Jan 2019'
  end

  def test_two_dates_on_different_year
    group_date = GroupDate.new(
      [
        Date.parse('31-12-2018'),
        Date.parse('02-01-2019')
      ]
    )
    assert_equal group_date.call, '31 Dec 2018 and 02 Jan 2019'
  end

  def test_three_consecutive_dates
    group_date = GroupDate.new(
      [
        Date.parse('01-01-2018'),
        Date.parse('02-01-2018'),
        Date.parse('03-01-2018')
      ]
    )
    assert_equal group_date.call, '01 to 03 Jan 2018'
  end

  def test_three_non_consecutives_dates
    group_date = GroupDate.new(
      [
        Date.parse('01-01-2018'),
        Date.parse('04-01-2018'),
        Date.parse('05-01-2018')
      ]
    )
    assert_equal group_date.call, '01 and 04 to 05 Jan 2018'
  end

  def test_four_non_consecutives_dates
    group_date = GroupDate.new(
      [
        Date.parse('01-01-2018'),
        Date.parse('04-01-2018'),
        Date.parse('05-01-2018'),
        Date.parse('06-01-2018')
      ]
    )
    assert_equal group_date.call, '01 and 04 to 06 Jan 2018'
  end

  def test_four_non_consecutives_dates_in_different_month_but_same_year
    group_date = GroupDate.new(
      [
        Date.parse('01-01-2018'),
        Date.parse('04-02-2018'),
        Date.parse('05-02-2018'),
        Date.parse('06-02-2018')
      ]
    )
    assert_equal group_date.call, '01 Jan and 04 to 06 Feb 2018'
  end

  def test_four_non_consecutives_dates_in_different_month_and_year
    group_date = GroupDate.new(
      [
        Date.parse('30-12-2018'),
        Date.parse('31-12-2018'),
        Date.parse('03-01-2019'),
        Date.parse('04-01-2019')
      ]
    )
    assert_equal group_date.call, '30 to 31 Dec 2018 and 03 to 04 Jan 2019'
  end

  def test_four_non_consecutives_dates_in_different_month
    group_date = GroupDate.new(
      [
        Date.parse('09-09-2018'),
        Date.parse('10-10-2018'),
        Date.parse('03-11-2018'),
        Date.parse('04-12-2018')
      ]
    )
    assert_equal group_date.call, '09 Sep, 10 Oct, 03 Nov and 04 Dec 2018'
  end

  def test_five_non_consecutives_dates_in_different_month
    group_date = GroupDate.new(
      [
        Date.parse('09-09-2018'),
        Date.parse('10-10-2018'),
        Date.parse('03-11-2018'),
        Date.parse('04-12-2018'),
        Date.parse('05-12-2018')
      ]
    )
    assert_equal group_date.call, '09 Sep, 10 Oct, 03 Nov and 04 to 05 Dec 2018'
  end

  def test_five_non_consecutives_dates_in_different_month_and_year
    group_date = GroupDate.new(
      [
        Date.parse('30-12-2018'),
        Date.parse('31-12-2018'),
        Date.parse('03-01-2019'),
        Date.parse('04-01-2019'),
        Date.parse('05-01-2019')
      ]
    )
    assert_equal group_date.call, '30 to 31 Dec 2018 and 03 to 05 Jan 2019'
  end

  def test_six_non_consecutives_dates_in_different_month_and_year
    group_date = GroupDate.new(
      [
        Date.parse('30-12-2017'),
        Date.parse('30-12-2018'),
        Date.parse('31-12-2018'),
        Date.parse('03-01-2019'),
        Date.parse('04-01-2019'),
        Date.parse('05-01-2019')
      ]
    )
    assert_equal group_date.call,
                 '30 Dec 2017, 30 to 31 Dec 2018 and 03 to 05 Jan 2019'
  end

  def test_five_non_consecutives_random_dates_in_different_month_and_year
    group_date = GroupDate.new(
      [
        Date.parse('29-12-2019'),
        Date.parse('30-12-2019'),
        Date.parse('02-01-2020'),
        Date.parse('03-01-2020'),
        Date.parse('05-01-2020')
      ]
    )
    assert_equal group_date.call,
                 '29 to 30 Dec 2019, 02 to 03 Jan and 05 Jan 2020'
  end
end
# rubocop:enable all
