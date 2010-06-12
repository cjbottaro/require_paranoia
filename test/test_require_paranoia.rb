require 'helper'

class TestRequireParanoia < Test::Unit::TestCase
  
  def test_basic
    Kernel.disable_require!
    assert_raises(RequireParanoia){ require "test/files/test1" }
    Kernel.enable_require!
    assert require("test/files/test1")
    
  end
  
  def test_with_block
    Kernel.disable_require! do
      assert_raises(RequireParanoia){ require "test/files/test2" }
    end
    assert require("test/files/test2")
  end
  
  def test_works_with_already_required_files
    assert require("test/files/test3")
    Kernel.disable_require! do
      assert require("test/files/test3")
    end
  end
  
  def test_enable_requires_actually_restores_original
    Kernel.disable_require! do
      assert_raises(RequireParanoia){ require "test/files/test4" }
    end
    assert !defined?(Test4)
    assert require("test/files/test4")
    assert defined?(Test4)
  end
  
end
