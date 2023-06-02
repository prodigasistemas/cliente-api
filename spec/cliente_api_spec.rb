require 'pry'
require 'spec_helper'

describe ClienteAPI do
  it 'has a version number' do
    expect(ClienteAPI::VERSION).not_to be nil
  end

  class DummyModel < ClienteAPI::Model
    attr_accessor :id, :title

    belongs_to :another_model
  end

  it 'has an URL' do
    expect(DummyModel::URL_BASE).not_to be nil
  end

  it 'has attributes' do
    dummy = DummyModel.new(id: 1, title: "title")

    expect(dummy.attributes.keys).not_to include("id")
    expect(dummy.attributes.keys).to include("title")
    expect(dummy.attributes["title"]).to eq("title")
  end

  it 'has crud operations for object' do
    dummy = DummyModel.new

    expect(dummy).to respond_to(:save)
    expect(dummy).to respond_to(:update)
    expect(dummy).to respond_to(:destroy)
    expect(dummy).to respond_to(:fetch_lazy)
  end

  it 'has associations' do
    dummy = DummyModel.new

    expect(dummy).to respond_to(:another_model)
  end

  it 'has crud operations for class' do
    expect(DummyModel).to respond_to(:create)
    expect(DummyModel).to respond_to(:all)
    expect(DummyModel).to respond_to(:where)
    expect(DummyModel).to respond_to(:find)
    expect(DummyModel).to respond_to(:filter)
  end

end
