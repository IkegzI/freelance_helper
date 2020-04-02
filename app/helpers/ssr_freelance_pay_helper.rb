module SsrFreelancePayHelper


  def select_mark_pay_freelance
    IssueCustomField.all.map { |item| [item.name, item.id] }
  end


  def self.check_field_on_pay
    # field = Setting.plugin_freelance_helper['sunstrike_freelance_pay_field_id'].to_i
    # if Setting.plugin_freelance_helper['sunstrike_freelance_pay_field_id'].to_i != 0
      # unless field_issue = IssueCustomField.find(field)
      # field_issue = IssueCustomField.find(field)
      unless IssueCustomField.find_by(name:"Способ оплаты фрилансеру")
        param = {
            name: "Способ оплаты фрилансеру",
            field_format: "list",
            possible_values: ["Карта Сбербанка", "Карта Райффайзен", "Киви кошелек", "Другая карта/способ"],
            regexp: "",
            min_length: nil,
            max_length: nil,
            is_required: false,
            is_for_all: true,
            is_filter: true,
            position: 3,
            searchable: false,
            default_value: "",
            editable: true,
            visible: true,
            multiple: false,
            format_store: {"url_pattern" => "", "edit_tag_style" => ""},
            description: "Способ оплаты фрилансеру"}
        ucf_pay = UserCustomField.new(param)
        ucf_pay.save
      end
      unless UserCustomField.find_by(name: "Способ оплаты фрилансеру")
        param = {
            name: "Способ оплаты фрилансеру",
            field_format: "list",
            possible_values: ["Карта Сбербанка", "Карта Райффайзен", "Киви кошелек", "Другая карта/способ"],
            regexp: "",
            min_length: nil,
            max_length: nil,
            is_required: false,
            is_for_all: true,
            is_filter: true,
            position: 3,
            searchable: false,
            default_value: "",
            editable: true,
            visible: true,
            multiple: false,
            format_store: {"url_pattern" => "", "edit_tag_style" => ""},
            description: "Способ оплаты фрилансеру"}
        ucf_pay = UserCustomField.new(param)
        ucf_pay.save
      end
      unless UserCustomField.find_by(name: "Номер карты/кошелька/телефона")
        ucf_wallet = UserCustomField.new(name: "Номер карты/кошелька/телефона",
                                         field_format: "string",
                                         possible_values: nil,
                                         regexp: "",
                                         min_length: nil,
                                         max_length: 40,
                                         is_required: false,
                                         is_for_all: false,
                                         is_filter: false,
                                         position: 7,
                                         searchable: false,
                                         default_value: "",
                                         editable: true,
                                         visible: true,
                                         multiple: false,
                                         format_store: {"text_formatting" => "",
                                                        "url_pattern" => ""},
                                         description: "")
        ucf_wallet.save
      end
      unless IssueCustomField.find_by(name: "Номер карты/кошелька/телефона")
        ucf_wallet = IssueCustomField.new(name: "Номер карты/кошелька/телефона",
                                          field_format: "string",
                                          possible_values: nil,
                                          regexp: "",
                                          min_length: nil,
                                          max_length: 40,
                                          is_required: false,
                                          is_for_all: true,
                                          is_filter: true,
                                          position: 7,
                                          searchable: false,
                                          default_value: "",
                                          editable: true,
                                          visible: true,
                                          multiple: false,
                                          format_store: {"text_formatting" => "",
                                                         "url_pattern" => ""},
                                          description: "")
        ucf_wallet.save
      end
    end
  end
# end
# end