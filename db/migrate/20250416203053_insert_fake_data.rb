class InsertFakeData < ActiveRecord::Migration[8.0]
  def up
    ## User
    user = User.create! name: "John Doe", email: "john.doe@test.com", password: "mjuf$9hdO)urbv"

    ## Doctor
    house = Doctor.create! name: "House", document_number: "123.456.789-10", crm: 456321, crm_location: "SP"
    ray = Doctor.create! name: "Ray", document_number: "987.654.321-01", crm: 789852, crm_location: "MG"

    ## Patient
    maria = Patient.create! name: "Maria das Dores", document_number: "741.258.963-65"
    neymar = Patient.create! name: "Neymar", document_number: "985.145.236-84"

    ## Medical Procedure
    medical_procedure_one = MedicalProcedure.create! name: "Dipirona intravenosa"
    medical_procedure_two = MedicalProcedure.create! name: "Imobilização de membro superior"
    medical_procedure_three = MedicalProcedure.create! name: "Raspagem"
    medical_procedure_four = MedicalProcedure.create! name: "Anestesia local"

    ## Medical Procedure Detail
    medical_procedure_one.details.create! price: 100
    medical_procedure_two.details.create! price: 270
    medical_procedure_three.details.create! price: 500
    medical_procedure_four.details.create! price: 75

    ## Treatment
    # 1
    treatment_one = Treatment.create! performed_at: Date.today
    treatment_one.details.create!({
      patient: maria,
      doctor: house,
      medical_procedure: medical_procedure_one,
      medical_procedure_detail: medical_procedure_one.detail
    })

    # 2
    treatment_two = Treatment.create! performed_at: Date.tomorrow
    treatment_two.details.create!({
      patient: neymar,
      doctor: ray,
      medical_procedure: medical_procedure_two,
      medical_procedure_detail: medical_procedure_two.detail
    })

    # 3
    treatment_three = Treatment.create! performed_at: Date.yesterday
    treatment_three.details.create!({
      patient: neymar,
      doctor: ray,
      medical_procedure: medical_procedure_three,
      medical_procedure_detail: medical_procedure_three.detail,
      status: :paid
    })

    # 4
    treatment_four = Treatment.create! performed_at: Date.today
    treatment_four.details.create!({
      patient: maria,
      doctor: house,
      medical_procedure: medical_procedure_four,
      medical_procedure_detail: medical_procedure_four.detail,
      status: :denied
    })
  end
end
