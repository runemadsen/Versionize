# describe "Member.members_for_csa" do
#   before do
#     @csa1 = mock(Csa, :name => "Csa1")
#     @o = mock(Offering, :csa => @csa1)
#     @csa1.stub!(:offerings => [@o])
#     @s1 = mock(Share, :offering => @o)
#     @s2 = mock(Share, :offering => @o)
#     @o.stub!(:shares => [@s1, @s2])
#     @u1 = mock(User, :shares => [@s1])
#     @u2 = mock(User, :shares => [@s2])
#     @s1.stub!(:user => @u1)
#     @s2.stub!(:user => @u2)
#     @u3 = mock(User)
#   end
#   
#   it "should return all members corresponding to the users who have shares in any of the CSA's offerings" do
#     Member.users_for_csa(@csa1).should == [@u1,@u2]
#   end
# 
# end