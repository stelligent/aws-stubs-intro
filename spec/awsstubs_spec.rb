require 'spec_helper'

# Using Aws.config, CloudFormation clients will return these stub responses when their corresponding methods are invoked
# First, we set up some stub data
stub_stacks = stubbed_stacks(how_many: 1)
stub_resource_summaries = stubbed_stack_summaries(how_many: 5)
use_index = 3
stub_resource_detail = stubbed_resource_detail(stack: stub_stacks.first, resource_summary: stub_resource_summaries[use_index])
# Second, we apply the various stub_data to specified Aws.config
Aws.config[:cloudformation] = {
  stub_responses: {
    describe_stacks: { stacks: stub_stacks },
    list_stack_resources: { stack_resource_summaries: stub_resource_summaries },
    describe_stack_resource: { stack_resource_detail: stub_resource_detail }
  }
}

describe AwsStubs do
  it 'has a version number' do
    expect(AwsStubs::VERSION).not_to be nil
  end

  let(:demo) { AwsStubs::CloudFormation.new(aws_region: 'any-value') }
  let(:stub_client) { Aws::CloudFormation::Client.new(stub_responses: true) }

  describe '#retrieve_stack' do
    context 'when retrieving an existing stack' do
      it 'returns a matching stack object' do
        expect(
          demo.retrieve_stack(stack_name: stub_stacks.first.stack_name)
        ).to struct_match(stub_stacks.first)
      end
    end
  end

  describe '#retrieve_resources' do
    context 'when retrieving the resource list of a stack' do
      it 'returns a list of stack resource summary objects' do
        expect(
          demo.retrieve_resources(stack_name: stub_stacks.first.stack_name)
        ).to struct_match(stub_resource_summaries)
      end
    end
  end

  describe '#retrieve_resource' do
    context 'when retrieving a particular resource by stack name and logical id' do
      it 'returns a list of stack resource summary objects' do
        expect(
          demo.retrieve_resource(
            stack_name: stub_stacks.first.stack_name,
            logical_resource_id: stub_resource_summaries[use_index].logical_resource_id
          )
        ).to struct_match(stub_resource_detail)
      end
    end
  end

  # The other way to implement Aws stubs:
  # (2) replace a client with its stub alter-ego
  #     the subsequent calls will return these stub responses for the corresponding methods
  describe '#retrieve_stack using a localized stub' do
    context 'when retrieving an existing stack' do
      it 'returns the matching stack object' do
        expect(Aws::CloudFormation::Client).to receive(:new).and_return(stub_client)
        stub_client.stub_responses(:describe_stacks, stacks: stub_stacks)

        expect(
          demo.retrieve_stack(stack_name: stub_stacks.first.stack_name)
        ).to struct_match(stub_stacks.first)
      end
    end
    context 'when retrieving a non-existing stack' do
      it 'returns nil' do
        expect(Aws::CloudFormation::Client).to receive(:new).and_return(stub_client)
        stub_client.stub_responses(:describe_stacks, stacks: [])

        expect(
          demo.retrieve_stack(stack_name: stub_stacks.first.stack_name)
        ).to be(nil)
      end
    end
  end

  # Forgot what the response should look like? Find out using:
  #   puts stub_client.stub_data(:client_method_name)
  describe '#retrieve_resources and test paging logic' do
    context 'when retrieving the resources for a stack having >100 resources' do
      it 'makes multiple calls using "next_token", and assembles the data internally' do
        #
        lots_of_stub_resource_summaries = stubbed_stack_summaries(how_many: 125)

        # intercept the AWS client’s constructor and substitute our stub client
        expect(Aws::CloudFormation::Client).to receive(:new).and_return(stub_client)

        # stub out the stack's existence so the verification call succeeds
        stub_client.stub_responses(:describe_stacks, stacks: stub_stacks)

        # mimic the condition causing multiple calls to the 'list_stack_resources' API:
        # in this case, non-stubbed calls would return only the *first 100* StackResourceSummary
        #   structs, and a not-nil 'next_token' attribute value indicating a paginated response
        stub_client.stub_responses(:list_stack_resources,
          Aws::CloudFormation::Types::ListStackResourcesOutput.new(
            stack_resource_summaries: lots_of_stub_resource_summaries[0..99],
            next_token: 'there-are-more'
          ),
          Aws::CloudFormation::Types::ListStackResourcesOutput.new(
            stack_resource_summaries: lots_of_stub_resource_summaries[100..124],
            next_token: nil
          )
        )

        # We expect ‘retrieve_resources’ will call the API twice in order to return
        #   an array containing all the stubbed stack_resource_summaries
        expect(demo.retrieve_resources(stack_name: 'stackname1'))
          .to eql(lots_of_stub_resource_summaries)
      end
    end
  end
end
