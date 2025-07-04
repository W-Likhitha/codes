package com.eureka;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

@SpringBootApplication
@EnableEurekaServer
public class EurekaRegistryApplication {
    public static void main(String[] args) {
        SpringApplication.run(EurekaRegistryApplication.class, args);
    }
}
package com.appointment.controller;

import java.util.List;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.appointment.dto.AppointmentRequestDTO;
import com.appointment.dto.AppointmentResponseDTO;
import com.appointment.dto.AppointmentUpdateDTO;
import com.appointment.dto.AvailabilityRequestDTO;
import com.appointment.dto.AvailabilityResponseDTO;
import com.appointment.dto.BookingResult;
import com.appointment.entity.Appointment;
import com.appointment.service.AppointmentService;


@RestController
@RequestMapping("Whospitals/profile/appointments")
public class AppointmentController {
    
    @Autowired
    private AppointmentService appointmentService;

    @PostMapping("/book")
    public ResponseEntity<BookingResult> bookAppointment(@Valid @RequestBody AppointmentRequestDTO request) {
        BookingResult result = appointmentService.bookOrWaitAppointment(request);
        return ResponseEntity.ok(result);
    }

    @PutMapping("/update/{appointmentId}")
    public ResponseEntity<Appointment> updateAppointment(@PathVariable Long appointmentId, @RequestBody AppointmentUpdateDTO updateDTO) {
        Appointment appointment = appointmentService.partialUpdateAppointment(appointmentId, updateDTO);
        return ResponseEntity.ok(appointment);
    }
    
    @PutMapping("/cancel/{appointmentId}")
    public ResponseEntity<Appointment> cancelAppointment(@PathVariable Long appointmentId) {
        Appointment appointment = appointmentService.cancelAppointment(appointmentId);
        return ResponseEntity.ok(appointment);
    }
    
    @GetMapping("/patient/{patientId}")
    public ResponseEntity<List<AppointmentResponseDTO>> getAppointmentsByPatient(@PathVariable Long patientId) {
        List<AppointmentResponseDTO> responseDTOs = appointmentService.getAppointmentResponseDTOsByPatient(patientId);
        return ResponseEntity.ok(responseDTOs);
    }
    
     //Retrieve available time slots for a doctor on a specific date.
    @GetMapping("/availability")
    public ResponseEntity<AvailabilityResponseDTO> getAvailability(@RequestBody AvailabilityRequestDTO request) {
        AvailabilityResponseDTO response = appointmentService.getAvailability(
                request.getDoctorId(),
                request.getDate());
        return ResponseEntity.ok(response);
    }
    
    @GetMapping("/view/{appointmentId}")
    public ResponseEntity<AppointmentResponseDTO> viewAppointment(@PathVariable Long appointmentId) {
    	AppointmentResponseDTO response = appointmentService.viewAppointment(appointmentId);
        return ResponseEntity.ok(response);
    }
}
package com.appointment.controller;

//import java.util.List;
//import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

//import com.appointment.dto.AppointmentRequestDTO;
//import com.appointment.dto.AppointmentResponseDTO;
//import com.appointment.dto.AppointmentUpdateDTO;
//import com.appointment.dto.AvailabilityRequestDTO;
//import com.appointment.dto.AvailabilityResponseDTO;
//import com.appointment.dto.BookingResult;
import com.appointment.dto.client.FollowupUpdateDTO;
//import com.appointment.entity.Appointment;
import com.appointment.service.AppointmentService;


@RestController
@RequestMapping("Whospitals/profile/appointments/update/followUp")
public class ExposeController {
    
    @Autowired
    private AppointmentService appointmentService;

    @PutMapping("/update/{appointmentId}")
    public FollowupUpdateDTO followupAppointment(@PathVariable Long appointmentId, @RequestBody FollowupUpdateDTO updateDTO) {
        FollowupUpdateDTO followUpEnabled = appointmentService.followupUpdate(appointmentId, updateDTO);
        return followUpEnabled;
    }
  
}
package com.appointment.dto;

import java.time.LocalDate;
import java.time.LocalTime;
import com.fasterxml.jackson.annotation.JsonFormat;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class AppointmentRequestDTO {
	
	@NotNull(message = "Patient ID is required")
    private Long patientId;
	
	@NotNull(message = "Doctor ID is required")
    private Long doctorId;
	
	@NotNull(message = "Appointment date is required")
    private LocalDate appointmentDate;
    
    @JsonFormat(pattern = "HH:mm")
    private LocalTime appointmentTime;

}

package com.appointment.dto;

import java.time.LocalDate;
import java.time.LocalTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AppointmentResponseDTO {
    private Long appointmentId;
    private LocalDate appointmentDate;
    private LocalTime appointmentTime;
    private String status;
    private DoctorResponseDTO doctor;
}
package com.appointment.dto;

import java.time.LocalDate;
import java.time.LocalTime;
import lombok.Data;

@Data
public class AppointmentUpdateDTO {
    // Optional: only update if provided. Fields left null won’t change.
    private LocalDate appointmentDate;
    private LocalTime appointmentTime;
    private Boolean followUp;
}
package com.appointment.dto;

import java.time.LocalDate;
import lombok.Data;

@Data
public class AvailabilityRequestDTO {
    private Long doctorId;
    private LocalDate date;
}

package com.appointment.dto;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import lombok.Data;

@Data
public class AvailabilityResponseDTO {
    private Long doctorId;
    private LocalDate date;
    private List<LocalTime> availableSlots;
}


package com.appointment.dto;

import com.appointment.entity.Appointment;
import com.appointment.entity.WaitingAppointment;

import lombok.Data;

@Data
public class BookingResult {
    // True if an appointment was successfully booked.
    private boolean booked;
    private Appointment appointment;
    private WaitingAppointment waitingAppointment;
    private String message;
}
package com.appointment.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DoctorResponseDTO {
    private Long doctorId;
    private String name;
    private String gender;
    private String roomNumber;
    private String specialization;
    private String qualification;
}
package com.appointment.dto.client;

import lombok.Data;

@Data
public class FollowupUpdateDTO {
	private boolean followup;
}
package com.appointment.dto.client;

import lombok.Data;

@Data
public class FollowupUpdateDTO {
	private boolean followup;
}
package com.appointment.dto.consumer;


import lombok.Data;

@Data
public class ProfileResponsePatient {
	private Long userId;
	private String name;
	private String gender;
	private Long patientId;
	private String disease;
	private String place;
}
package com.appointment.dto.consumer;

import lombok.Data;

@Data
public class ProfileRespsoneUser {
	private Long userId;
	private String Role;
}
package com.appointment.entity;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalTime;
import lombok.Data;
import com.fasterxml.jackson.annotation.JsonIgnore;

@Data
@Entity
@Table(name = "appointments")
public class Appointment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long appointmentId;
    
    // Store only the doctor identifier instead of a full association.
    @Column(name = "doctor_id", nullable = false)
    private Long doctorId;
    
    // Store only the patient identifier.
    @Column(name = "patient_id", nullable = false)
    private Long patientId;
    
    @Column(name = "appointment_date")
    private LocalDate appointmentDate;
    
    @Column(name = "appointment_time")
    private LocalTime appointmentTime;
    
    @Enumerated(EnumType.STRING)
    private AppointmentStatus status;
    
    @JsonIgnore
    private boolean followUp;
}
package com.appointment.entity;

public enum AppointmentStatus {
    BOOKED,
    CANCELLED,
    COMPLETED
}
package com.appointment.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "waiting_appointments")
public class WaitingAppointment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    // Instead of a direct association, store the doctor ID.
    @Column(name = "doctor_id", nullable = false)
    private Long doctorId;

    // Instead of a direct association, store the patient ID.
    @Column(name = "patient_id", nullable = false)
    private Long patientId;

    @Column(name = "preferred_time")
    private LocalDateTime preferredTime;
    
    @Column(name = "requested_at")
    private LocalDateTime requestedAt = LocalDateTime.now();
}
package com.appointment.exception;

import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;

//import com.example.demo.exception.GlobalExceptionHandler;

import org.slf4j.*;

@ControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler(Exception.class)
    public ResponseEntity<String> handleAllExceptions(Exception ex) {
         logger.error("An error occurred: {}", ex.getMessage(), ex);
         return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                 .body("An unexpected error occurred: " + ex.getMessage());
    }
}
package com.appointment.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.BAD_REQUEST)
public class InvalidAppointmentTimeException extends RuntimeException {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public InvalidAppointmentTimeException(String message) {
        super(message);
    }
}
package com.appointment.feign;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

//import com.appointment.dto.DoctorResponseDTO;
import com.appointment.dto.consumer.ProfileResponseDoctor;
import com.appointment.dto.consumer.ProfileResponsePatient;
import com.appointment.dto.consumer.ProfileRespsoneUser;

@FeignClient(name = "UserManagement")
public interface UserServiceClient {

    @GetMapping("/Whospitals/profile/doctorId/{doctorId}")
    ProfileResponseDoctor getDoctorDetails(@PathVariable("doctorId") Long doctorId);
    
    @GetMapping("/Whospitals/profile/patientId/{patientId}")
    ProfileResponsePatient getPatientDetails(@PathVariable("patientId") Long patientId);
    
    @GetMapping("/Whospitals/profile/{userId}")
    ProfileRespsoneUser getUserDetails(@PathVariable("userId") Long userId);
}

package com.appointment.repository;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.appointment.entity.Appointment;
import com.appointment.entity.AppointmentStatus;


@Repository
public interface AppointmentRepository extends JpaRepository<Appointment, Long> {

    // Find appointments by the patient’s ID
    List<Appointment> findByPatientId(Long patientId);

    // Find appointments for a given doctor on a specific date.
    List<Appointment> findByDoctorIdAndAppointmentDate(Long doctorId, LocalDate appointmentDate);

    // Find first appointment that matches doctor, patient, date, and start time (for duplicate checking).
    Appointment findFirstByDoctorIdAndPatientIdAndAppointmentDateAndAppointmentTime(
            Long doctorId, Long patientId, LocalDate date, LocalTime startTime);
    
    // Retrieve appointments with a specified date and status.
    List<Appointment> findByAppointmentDateAndStatus(LocalDate appointmentDate, AppointmentStatus status);
}
package com.appointment.repository;

import java.time.LocalDateTime;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.appointment.entity.WaitingAppointment;
//import com.example.demo.entity.User;

@Repository
public interface WaitingAppointmentRepository extends JpaRepository<WaitingAppointment, Long> {
    List<WaitingAppointment> findByDoctorIdAndPreferredTimeBetween(Long doctorId, LocalDateTime start, LocalDateTime end);
    
    // Add this method to find waiting list records for a specific doctor and patient.
    List<WaitingAppointment> findByDoctorIdAndPatientId(Long doctorId, Long patientId);
}
package com.appointment.scheduler;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.appointment.service.AppointmentService;

@Component
public class AppointmentScheduler {

    @Autowired
    private AppointmentService appointmentService;

    // This cron expression runs at 18:00s
    @Scheduled(cron = "0 0 18 * * ?")
    public void cancelOverdueAppointmentsTask() {
        appointmentService.cancelOverdueAppointments();
    }

}
package com.appointment.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.appointment.dto.AppointmentRequestDTO;
import com.appointment.dto.AppointmentResponseDTO;
import com.appointment.dto.AppointmentUpdateDTO;
import com.appointment.dto.AvailabilityResponseDTO;
import com.appointment.dto.BookingResult;
import com.appointment.dto.DoctorResponseDTO;
import com.appointment.dto.client.FollowupUpdateDTO;
import com.appointment.dto.consumer.ProfileResponseDoctor;
import com.appointment.dto.consumer.ProfileResponsePatient;
import com.appointment.entity.Appointment;
import com.appointment.entity.AppointmentStatus;
import com.appointment.entity.WaitingAppointment;
import com.appointment.feign.UserServiceClient;
import com.appointment.repository.AppointmentRepository;
import com.appointment.repository.WaitingAppointmentRepository;
//import com.hospital.management.entity.Role;
//import com.hospital.management.entity.Doctor;
//import com.hospital.management.entity.Patient;
//import com.hospital.management.repository.DoctorRepository;
//import com.hospital.management.repository.PatientRepository;

@Service
public class AppointmentService {

	private static final Logger logger = LoggerFactory.getLogger(AppointmentService.class);

	@Autowired
	private AppointmentRepository appointmentRepository;

	@Autowired
	private WaitingAppointmentRepository waitingAppointmentRepository;

	@Autowired
	private UserServiceClient userServiceClient;

//	@Autowired
//	private PatientRepository patientRepository;
//
//	@Autowired
//	private DoctorRepository doctorRepository;

	// Hospital working hours and breaks.
	private final LocalTime WORK_START = LocalTime.of(9, 30);
	private final LocalTime WORK_END = LocalTime.of(18, 0);
	private final LocalTime LUNCH_START = LocalTime.of(13, 0);
	private final LocalTime LUNCH_END = LocalTime.of(14, 30);
	private final LocalTime FOLLOWUP_ALLOWED_START = LocalTime.of(16, 0);
	private final int SLOT_DURATION_MINUTES = 30;

//	 Utility Validation Methods
//	 Validate that a 30-minute slot fits completely within hospital hours.
	private void validateHospitalHours(LocalTime startTime) {
		if (startTime.isBefore(WORK_START) || startTime.plusMinutes(SLOT_DURATION_MINUTES).isAfter(WORK_END)) {
			throw new RuntimeException(
					"Appointment must be scheduled between 9:30 and 17:30 so that it finishes by 18:00.");
		}
	}

	// For regular(non-follow-up)appointments.
	private void validateRegularAppointment(LocalTime startTime) {

		if (startTime.isBefore(LUNCH_END) && startTime.plusMinutes(SLOT_DURATION_MINUTES).isAfter(LUNCH_START)) {
			throw new RuntimeException("Regular appointments cannot overlap the lunch break (13:00 to 14:30).");
		}
		if (!startTime.isBefore(FOLLOWUP_ALLOWED_START)) {
			logger.warn("Regular appointments not allowed between 16:00 and 18:00 at {}", startTime);
			throw new RuntimeException(
					"Regular appointments are not allowed between 16:00 and 18:00. For that period, select follow-up.");
		}
	}

	// Booking Methods
	@Transactional
	public BookingResult bookOrWaitAppointment(AppointmentRequestDTO request) {
		logger.info("Attempting to book appointment for patient {} with doctor {} on {} at {}", request.getPatientId(),
				request.getDoctorId(), request.getAppointmentDate(), request.getAppointmentTime());
		// Extract values from the DTO.
		Long patientId = request.getPatientId();
		Long doctorId = request.getDoctorId();
		LocalDate appointmentDate = request.getAppointmentDate();
		LocalTime appointmentTime = request.getAppointmentTime();
		LocalDateTime appointmentDateTime = LocalDateTime.of(appointmentDate, appointmentTime);

		if (appointmentDateTime.isBefore(LocalDateTime.now())) {
			logger.error("Booking failed: Cannot book an appointment in the past.");
			throw new IllegalArgumentException("Cannot book an appointment in the past.");
		}
		BookingResult result = new BookingResult();

		// Retrieve patient and doctor using their dedicated repositories.
		ProfileResponsePatient patient = userServiceClient.getPatientDetails(patientId);
		if(patient == null) {
			throw new RuntimeException("Patient not found");
		}
		
		ProfileResponseDoctor doctor = userServiceClient.getDoctorDetails(doctorId);
		if(doctor == null) {
			throw new RuntimeException("Doctor not found");
		}

		LocalDate date = appointmentDateTime.toLocalDate();
		LocalTime startTime = appointmentDateTime.toLocalTime();

		// Duplicate Check
		// Check if a booked appointment for the same doctor, patient, date, and time
		// exists.
		Appointment duplicateAppointment = appointmentRepository
				.findFirstByDoctorIdAndPatientIdAndAppointmentDateAndAppointmentTime(doctorId, patientId, date,
						startTime);
		if (duplicateAppointment != null) {
			logger.warn("Duplicate booking detected for patient {} with doctor {} on {} at {}", patientId, doctorId,
					date, startTime);
			throw new RuntimeException("Duplicate booking: an appointment for this slot already exists.");
		}

		// Check if the patient is already on the waiting list for the same doctor and
		// slot.
		List<WaitingAppointment> existingWaiting = waitingAppointmentRepository.findByDoctorIdAndPatientId(doctorId,
				patientId);
		if (existingWaiting != null && !existingWaiting.isEmpty()) {
			for (WaitingAppointment wait : existingWaiting) {
				if (wait.getPreferredTime().toLocalDate().equals(date)
						&& wait.getPreferredTime().toLocalTime().equals(startTime)) {

					logger.warn("Duplicate waiting detected for patient {} with doctor {} at {}", patientId, doctorId,
							startTime);
					throw new RuntimeException("Duplicate waiting: You are already on the waiting list for this slot.");
				}
			}
		}

		validateHospitalHours(startTime);
		validateRegularAppointment(startTime);

		LocalTime endTime = startTime.plusMinutes(SLOT_DURATION_MINUTES);
		List<Appointment> existingAppointments = appointmentRepository.findByDoctorIdAndAppointmentDate(doctorId, date);
		boolean slotAvailable = true;
		// Check for overlaps with existing appointments.
		for (Appointment a : existingAppointments) {
			LocalTime exStart = a.getAppointmentTime();
			LocalTime exEnd = exStart.plusMinutes(SLOT_DURATION_MINUTES);
			if (startTime.isBefore(exEnd) && exStart.isBefore(endTime)) {
				slotAvailable = false;
				break;
			}
		}
		if (slotAvailable) {
			logger.info("Slot available. Booking appointment for patient {} with doctor {} at {}", patientId, doctorId,
					startTime);
			// Create a new Appointment.
			Appointment appointment = new Appointment();
			appointment.setPatientId(patientId);
			appointment.setDoctorId(doctorId);
			appointment.setAppointmentDate(date);
			appointment.setAppointmentTime(startTime);
			appointment.setStatus(AppointmentStatus.BOOKED);
			// appointment.setFollowUp(followUp);
			Appointment saved = appointmentRepository.saveAndFlush(appointment);
			result.setBooked(true);
			result.setAppointment(saved);
			result.setMessage("Appointment booked successfully.");
			// Remove waiting records for this patient and doctor if any exist.
			List<WaitingAppointment> waitingRecords = waitingAppointmentRepository.findByDoctorIdAndPatientId(doctorId,
					patientId);
			if (waitingRecords != null && !waitingRecords.isEmpty()) {
				waitingAppointmentRepository.deleteAll(waitingRecords);
				waitingAppointmentRepository.flush();
				logger.info("Removed waiting records for patient {} with doctor {}", patientId, doctorId);
			}
		} else {
			logger.warn("Requested slot is full. Adding patient {} to the waiting list for doctor {} at {}", patientId,
					doctorId, startTime);
			// Slot unavailable: add patient to waiting list.
			WaitingAppointment waiting = addToWaitingList(patientId, doctorId, appointmentDateTime);
			result.setBooked(false);
			result.setWaitingAppointment(waiting);
			result.setMessage("Requested slot is full. You have been added to the waiting list automatically.");
		}

		return result;
	}

	@Transactional
	public Appointment partialUpdateAppointment(Long appointmentId, AppointmentUpdateDTO updateDTO) {
		logger.info("Updating appointment {} with provided details", appointmentId);
		// 1. Retrieve the existing appointment.
		Appointment appointment = appointmentRepository.findById(appointmentId)
				.orElseThrow(() -> new RuntimeException("Appointment not found"));

		// Preserve the current (old) appointment slot.
		LocalDate oldDate = appointment.getAppointmentDate();
		LocalTime oldTime = appointment.getAppointmentTime();

		// 2. Update only the provided fields using explicit checks.
		if (updateDTO.getAppointmentDate() != null) {
			logger.debug("Updating appointment {} date from {} to {}", appointmentId, oldDate,
					updateDTO.getAppointmentDate());
			appointment.setAppointmentDate(updateDTO.getAppointmentDate());
		}
		if (updateDTO.getAppointmentTime() != null) {
			logger.debug("Updating appointment {} time from {} to {}", appointmentId, oldTime,
					updateDTO.getAppointmentTime());
			appointment.setAppointmentTime(updateDTO.getAppointmentTime());
		}

		// Determine the new slot from the updated appointment.
		LocalDate newDate = appointment.getAppointmentDate();
		LocalTime newTime = appointment.getAppointmentTime();
		LocalDateTime newDateTime = LocalDateTime.of(newDate, newTime);

		// 3. Validate the new date/time.
		if (newDateTime.isBefore(LocalDateTime.now())) {
			throw new IllegalArgumentException("The appointment date/time cannot be in the past.");
		}

		validateHospitalHours(newTime);
		validateRegularAppointment(newTime);

		// 4. Save and flush the updated appointment.
		Appointment updatedAppointment = appointmentRepository.saveAndFlush(appointment);
		logger.info("Appointment {} updated successfully", appointmentId);

		// 5. If the slot has changed, then the old slot is now freed.
		if (!oldDate.equals(newDate) || !oldTime.equals(newTime)) {
			// The old slot is represented by oldDate + oldTime.
			LocalDateTime oldSlot = LocalDateTime.of(oldDate, oldTime);
			// Look for any waiting candidate for the exact same old slot.
			List<WaitingAppointment> waitingCandidates = waitingAppointmentRepository
					.findByDoctorIdAndPreferredTimeBetween(appointment.getDoctorId(), oldSlot, oldSlot);
			if (waitingCandidates != null && !waitingCandidates.isEmpty()) {
				WaitingAppointment candidate = waitingCandidates.get(0);
				// Create a new appointment for the waiting candidate using the old (vacated)
				// slot.
				Appointment reassignedAppointment = new Appointment();
				reassignedAppointment.setDoctorId(appointment.getDoctorId());
				reassignedAppointment.setPatientId(candidate.getPatientId());
				reassignedAppointment.setAppointmentDate(oldDate);
				reassignedAppointment.setAppointmentTime(oldTime);
				reassignedAppointment.setStatus(AppointmentStatus.BOOKED);
				appointmentRepository.saveAndFlush(reassignedAppointment);
				// Remove the candidate from the waiting list.
				waitingAppointmentRepository.delete(candidate);
//				logger.info("Reassigned old slot {} {} to waiting patient {}", oldDate, oldTime,
//						candidate.getPatientId().getUserId().getName());
			}
		}

		return updatedAppointment;
	}

	// Convert Appointment entities to AppointmentResponseDTOs.
	public List<AppointmentResponseDTO> getAppointmentResponseDTOsByPatient(Long patientId) {
		logger.info("Fetching appointment details for patient ID: {}", patientId);

		List<Appointment> appointments = appointmentRepository.findByPatientId(patientId);

		if (appointments.isEmpty()) {
			logger.warn("No appointments found for patient ID: {}", patientId);
		}

		List<AppointmentResponseDTO> responseDTOs = new ArrayList<>();

		for (Appointment appointment : appointments) {
			ProfileResponseDoctor doctorDetails = null;
			if (appointment.getDoctorId() != null) {
				try {
					// Fetch doctor details using the Feign client
					doctorDetails = userServiceClient.getDoctorDetails(appointment.getDoctorId());
				} catch (Exception ex) {
					logger.error("Error fetching doctor details for doctor ID: {}", appointment.getDoctorId(), ex);
					// Optionally, set doctorDetails to a fallback value if needed
				}
			}

			DoctorResponseDTO dt = new DoctorResponseDTO();
			dt.setName(doctorDetails.getName());
			dt.setDoctorId(doctorDetails.getDoctorId());
			dt.setGender(doctorDetails.getGender());
			dt.setQualification(doctorDetails.getQualification());
			dt.setSpecialization(doctorDetails.getSpecialization());
			dt.setRoomNumber(doctorDetails.getRoomNumber());

			AppointmentResponseDTO responseDTO = AppointmentResponseDTO.builder()
					.appointmentId(appointment.getAppointmentId()).appointmentDate(appointment.getAppointmentDate())
					.appointmentTime(appointment.getAppointmentTime()).status(appointment.getStatus().name()).doctor(dt) // Doctor
																															// details
																															// now
																															// come
																															// from
																															// the
																															// external
																															// service
					.build();

			responseDTOs.add(responseDTO);
		}

		logger.info("Successfully retrieved {} appointments for patient ID: {}", responseDTOs.size(), patientId);
		return responseDTOs;
	}

	@Transactional
	public WaitingAppointment addToWaitingList(Long patientId, Long doctorId, LocalDateTime preferredTime) {
		logger.info("Adding patient {} to waiting list for doctor {} at {}", patientId, doctorId, preferredTime);
		ProfileResponsePatient patient = null;
		ProfileResponseDoctor doctor = null;
		if (patientId != null) {
			try {
				patient = userServiceClient.getPatientDetails(patientId);
				if (!(userServiceClient.getUserDetails(patient.getUserId()).getRole().toString().equals("PATIENT"))) {
					logger.warn("Invalid role: The provided patientId {} does not belong to a patient.", patientId);
					throw new RuntimeException("The provided patientId does not belong to a patient.");
				}
			} catch (Exception ex) {
				logger.error("Error fetching patient details for patient ID: {}", patientId, ex);
			}
		}
		if (doctorId != null) {
			try {
				doctor = userServiceClient.getDoctorDetails(doctorId);
				if (!(userServiceClient.getUserDetails(doctor.getUserId()).getRole().toString().equals("DOCTOR"))) {
					logger.warn("Invalid role: The provided doctorId {} does not belong to a doctor.", doctorId);
					throw new RuntimeException("The provided doctorId does not belong to a doctor.");
				}
			} catch (Exception ex) {
				logger.error("Error fetching patient details for patient ID: {}", patientId, ex);
			}
		}

		WaitingAppointment waiting = new WaitingAppointment();
		waiting.setPatientId(patientId);
		waiting.setDoctorId(doctorId);
		waiting.setPreferredTime(preferredTime);

		WaitingAppointment savedWaiting = waitingAppointmentRepository.saveAndFlush(waiting);
		logger.info("Successfully added patient {} to waiting list for doctor {} at {}", patientId, doctorId,
				preferredTime);

		return savedWaiting;

	}

	@Transactional
	public Appointment cancelAppointment(Long appointmentId) {
		logger.info("Attempting to cancel appointment with ID: {}", appointmentId);
		// Fetch the appointment to be canceled.
		Appointment appointment = appointmentRepository.findById(appointmentId)
		        .orElseThrow(() -> {
		            logger.error("Appointment {} not found", appointmentId);
		            return new RuntimeException("Appointment not found");
		        });

		// Build a LocalDateTime for the appointment and define a ±15-minute window.
		LocalDateTime apptDateTime = appointment.getAppointmentDate().atTime(appointment.getAppointmentTime());
		LocalDateTime startWindow = apptDateTime.minusMinutes(15);
		LocalDateTime endWindow = apptDateTime.plusMinutes(15);

		// Look for waiting appointments for the same doctor within this window.
		List<WaitingAppointment> waitingList = waitingAppointmentRepository
				.findByDoctorIdAndPreferredTimeBetween(appointment.getDoctorId(), startWindow, endWindow);

		// If there are waiting appointments, reassign the appointment.
		if (waitingList != null && !waitingList.isEmpty()) {
			WaitingAppointment waiting = waitingList.get(0);
			appointment.setPatientId(waiting.getPatientId());
			appointment.setStatus(AppointmentStatus.BOOKED);
		} else {
			appointment.setStatus(AppointmentStatus.CANCELLED);
		}

		Appointment updatedAppointment = appointmentRepository.save(appointment);

		// Cleanup: remove waiting records if present.
		if (waitingList != null && !waitingList.isEmpty()) {
			waitingAppointmentRepository.deleteAll(waitingList);
			waitingAppointmentRepository.flush();
			logger.info("Removed {} waiting records after appointment cancellation.", waitingList.size());
		}
		logger.info("Cancelled appointment {}. New status: {}", appointmentId, updatedAppointment.getStatus());
		return updatedAppointment;

	}

	public AvailabilityResponseDTO getAvailability(Long doctorId, LocalDate date) {
		 logger.info("Checking availability for doctor {} on {}", doctorId, date);
		AvailabilityResponseDTO response = new AvailabilityResponseDTO();
		response.setDoctorId(doctorId);
		response.setDate(date);
		response.setAvailableSlots(getAvailableTimeSlots(doctorId, date));
		logger.info("Availability check completed for doctor {} on {}: {} slots available", 
		        doctorId, date, response.getAvailableSlots().size());
		return response;

	}

	public List<LocalTime> getAvailableTimeSlots(Long doctorId, LocalDate date) {
	    logger.info("Fetching available time slots for doctor {} on {}", doctorId, date);
		ProfileResponseDoctor doctor = userServiceClient.getDoctorDetails(doctorId);
				if(doctor == null) {
					throw new RuntimeException("Doctor not found");
				}

		List<LocalTime> slots = new ArrayList<>();
		LocalTime slotTime = WORK_START;
		while (!slotTime.plusMinutes(30).isAfter(WORK_END)) {
			// Exclude slots overlapping lunch.
			if (!(slotTime.isBefore(LUNCH_END) && slotTime.plusMinutes(30).isAfter(LUNCH_START))) {
				slots.add(slotTime);
			}
			slotTime = slotTime.plusMinutes(30);
		}

		List<Appointment> appointments = appointmentRepository.findByDoctorIdAndAppointmentDate(doctorId, date);
		for (Appointment a : appointments) {
			if (a.getStatus() == AppointmentStatus.BOOKED) {
				slots.remove(a.getAppointmentTime());
			}
		}
	    logger.info("Available slots for doctor {} on {}: {}", doctorId, date, slots);
		return slots;
	}
	
	@Transactional
	public void cancelOverdueAppointments() {
		LocalDate today = LocalDate.now();
		LocalTime currentTime = LocalTime.now();
		logger.info("Checking for overdue appointments on {}", today);

		List<Appointment> appointments = appointmentRepository.findByAppointmentDateAndStatus(today,
				AppointmentStatus.BOOKED);

		for (Appointment appointment : appointments) {
			if (appointment.getAppointmentTime().isBefore(currentTime)) {
				logger.info("Cancelling overdue appointment {} scheduled for {} {}", 
		                appointment.getAppointmentId(), appointment.getAppointmentDate(), appointment.getAppointmentTime());
				
				appointment.setStatus(AppointmentStatus.CANCELLED);
				appointmentRepository.save(appointment);

				LocalDateTime appointmentDateTime = appointment.getAppointmentDate()
						.atTime(appointment.getAppointmentTime());
				LocalDateTime startWindow = appointmentDateTime.minusMinutes(15);
				LocalDateTime endWindow = appointmentDateTime.plusMinutes(15);

				List<WaitingAppointment> waitingList = waitingAppointmentRepository
						.findByDoctorIdAndPreferredTimeBetween(appointment.getDoctorId(), startWindow, endWindow);

				if (waitingList != null && !waitingList.isEmpty()) {
					waitingAppointmentRepository.deleteAll(waitingList);
					waitingAppointmentRepository.flush();
				}
			}
		}
		logger.info("Cancelled overdue appointments for {}", today);
	}

	public AppointmentResponseDTO viewAppointment(Long appointmentId) {
		Optional<Appointment> appointmentOpt = appointmentRepository.findById(appointmentId);
		if(appointmentOpt.isEmpty()) {
			throw new RuntimeException("Apppointment with the given id does not exist");
		}
		Appointment appointment = appointmentOpt.get();
		AppointmentResponseDTO appointmentDetails = new AppointmentResponseDTO();
		appointmentDetails.setAppointmentDate(appointment.getAppointmentDate());
		appointmentDetails.setAppointmentId(appointment.getAppointmentId());
		appointmentDetails.setAppointmentTime(appointment.getAppointmentTime());
		appointmentDetails.setStatus(appointment.getStatus().toString());
		DoctorResponseDTO dt  = new DoctorResponseDTO();
		ProfileResponseDoctor doctor = userServiceClient.getDoctorDetails(appointment.getDoctorId());
		dt.setDoctorId(appointment.getDoctorId());
		dt.setGender(doctor.getGender());
		dt.setName(doctor.getName());
		dt.setQualification(doctor.getQualification());
		dt.setSpecialization(doctor.getSpecialization());
		dt.setRoomNumber(doctor.getRoomNumber());
		appointmentDetails.setDoctor(dt);
		return appointmentDetails;
	}

	public FollowupUpdateDTO followupUpdate(Long appointmentId, FollowupUpdateDTO updateDTO) {
		FollowupUpdateDTO followupStatus = new FollowupUpdateDTO();
		followupStatus.setFollowup(updateDTO.isFollowup());
		Optional<Appointment> optAppointment = appointmentRepository.findById(appointmentId);
		if(optAppointment.isEmpty()) {
			throw new RuntimeException("");
		}
		Appointment appointment = optAppointment.get();
		Appointment updatedAppointment = new Appointment();
		updatedAppointment.setAppointmentId(appointment.getAppointmentId());
		updatedAppointment.setAppointmentDate(appointment.getAppointmentDate());
		updatedAppointment.setAppointmentTime(appointment.getAppointmentTime());
		updatedAppointment.setDoctorId(appointment.getDoctorId());
		updatedAppointment.setFollowUp(updateDTO.isFollowup());
		updatedAppointment.setPatientId(appointment.getPatientId());
		updatedAppointment.setStatus(AppointmentStatus.COMPLETED);
		appointmentRepository.saveAndFlush(updatedAppointment);
		return followupStatus;
	}
}
spring.application.name=AppointmentScheduling

# Server configuration
server.port=8086

eureka.client.service-url.defaultZone=http://localhost:8761/eureka/

spring.datasource.url=jdbc:mysql://localhost:3306/appointment_db
spring.datasource.username=root
spring.datasource.password=root
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver


# Automatically manage the database schema (options: create, update, create-drop, validate)
spring.jpa.hibernate.ddl-auto=update

# Show SQL statements in the logs
spring.jpa.show-sql=true

# Format SQL output in logs (optional)
spring.jpa.properties.hibernate.format_sql=true

# Specify the Hibernate dialect manually (this can help when JDBC metadata is not available)
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect
<?xml version="1.0" encoding="UTF-8"?>
<project
    xmlns="http://maven.apache.org/POM/4.0.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">

    <modelVersion>4.0.0</modelVersion>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.5.0</version>
        <relativePath /> <!-- lookup parent from repository -->
    </parent>

    <groupId>com.appschl</groupId>
    <artifactId>AppointmentScheduling</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>AppointmentScheduling</name>
    <description>This module is for appointment management</description>

    <properties>
        <java.version>17</java.version>
        <!-- Define the Spring Cloud version if you need it -->
        <spring-cloud.version>2025.0.0</spring-cloud.version>
    </properties>

    <!-- Spring Cloud Dependency Management -->
    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>${spring-cloud.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>

    <dependencies>
        <!-- Spring Boot Starters -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-security</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web-services</artifactId>
        </dependency>

        <!-- MySQL Connector -->
        <dependency>
            <groupId>com.mysql</groupId>
            <artifactId>mysql-connector-j</artifactId>
            <scope>runtime</scope>
        </dependency>

        <!-- Lombok -->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>

        <!-- Spring Boot Starter Test -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.springframework.security</groupId>
            <artifactId>spring-security-test</artifactId>
            <scope>test</scope>
        </dependency>

        <!-- Spring Boot Configuration Processor -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-configuration-processor</artifactId>
            <optional>true</optional>
        </dependency>

        <!-- Spring Boot Starter (if needed) -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter</artifactId>
        </dependency>

        <!-- Spring Cloud OpenFeign Dependency -->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-openfeign</artifactId>
        </dependency>

        <!-- Spring Cloud LoadBalancer -->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-loadbalancer</artifactId>
        </dependency>

        <!-- Eureka Client Dependency: Added so that the service can register with Eureka -->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
        </dependency>

        <!-- Spring Boot Starter Validation -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-validation</artifactId>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <!-- Maven Compiler Plugin (with Lombok support) -->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <configuration>
                    <annotationProcessorPaths>
                        <path>
                            <groupId>org.projectlombok</groupId>
                            <artifactId>lombok</artifactId>
                        </path>
                    </annotationProcessorPaths>
                </configuration>
            </plugin>
            <!-- Spring Boot Maven Plugin -->
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <configuration>
                    <excludes>
                        <exclude>
                            <groupId>org.projectlombok</groupId>
                            <artifactId>lombok</artifactId>
                        </exclude>
                    </excludes>
                </configuration>
            </plugin>
        </plugins>
    </build>

</project>


### ✅ Integration Overview

1. **Authenticate** → JWT stored (`localStorage.setItem('authToken', token)`).
2. **Email from token** via `AuthService.getUserEmail()`.
3. **Service methods** send JWT in headers and call backend endpoints.
4. **Components** refresh UI dynamically from live backend data.

Let me know if you’d like to add guards, routing, update forms, or style tweaks!

Here are the Angular CLI commands to generate the components (containers/pages) for your Healthcare Appointment Management System frontend based on your blueprint:

---

### ✅ **First, make sure you're in your Angular project root folder:**

```bash
cd healthcare-appointment-project
```

---

### 🏠 **1. Home Page Component**

```bash
ng generate component pages/home
```

---

### 👨‍⚕️ **2. All Doctors Page**

```bash
ng generate component pages/all-doctors
```

---

### 🧑‍⚕️ **3. Doctor Dashboard**

```bash
ng generate component pages/dashboard-doctor
```

---

### 👩‍⚕️ **4. Patient Dashboard**

```bash
ng generate component pages/dashboard-patient
```

---

### 📅 **5. Appointment Booking Page**

```bash
ng generate component pages/book-appointment
```

---

### 🔐 **6. Login Page**

```bash
ng generate component auth/login
```

---

### 📝 **7. Register Page**

```bash
ng generate component auth/register
```

---

### 💬 **8. About Page (Optional)**

```bash
ng generate component pages/about
```

---

### 📞 **9. Contact Page (Optional)**

```bash
ng generate component pages/contact
```

---

### 🧩 **10. Shared Header / Navigation Bar**

```bash
ng generate component shared/header
```

---

### 🧩 **11. Shared Footer (Optional)**

```bash
ng generate component shared/footer
```

---

### 🛠️ Optional: Create a Service for Auth and API Integration

```bash
ng generate service services/auth
ng generate service services/doctor
ng generate service services/patient
ng generate service services/appointment
```

now implement the frontend where in the header containing Home,AllDoctors,About,Contact and when clicked on Home then at the left logo and at the right Register/login button and in the page like we need div with background image in the middle page and the text in highlighted in the middle left like "Book Appointment with trusted doctors" and by the continue under that some images in round on round with some doctor faces next to that add text like Simply browse through our extensive list of trusted doctors, schedule your appointment hassel-free , after under that book appointment button, if we click that it should ask to register/login.when we click the Register/login at top right then it should redirect to login page where in header left up logo and right up "doesnt have an account SignUp. and in the page middle logo under that loging with YHospitals under that the email and the password like it shouuld have show and hide the password. and a forgot password? and at last login button. when u click on top left singup it should redirect to page where left logo and right already have an account SignIn, in the page SingUp for Whospitals and under that email,password,username,gender,phone number, role should be drop down option with doctor and patient and when a person select that it should show seperate extra fields to fill like, when a person clicks doctor it should have specialization,qualification.. and when patient it should give place.. give all required fields by the backend i gave and all under that give submit button and all should be compulsory fill except the room number in doctor and disease in patient. and when pressed Alldoctors the the doctor details should display along with their name,specialization and available or not, in each doctor in seperate box where then can see the list of doctors,. after login the should have a option to book the appointment , like they need to book by particular time slot so it would be good if we give drop down of time slots where they can select the doctor ,date,time. and the dashboard should be different if the user logins as patient and different when logged in as doctor. when logged in as doctor he need to be able to see the list of appointments he have along with the patient details , where he can change the followup, and he makes an appointment completed(pending,completed, so he needs completed button) and he should also change if by mistakenlyn he clicks complete then to change it.all the required add them and if logged in as patient he should have book appointments and need to have list of appointments whether its pending or completed ,he/ she can able to update the appointment, cancel the appointment,all extra details .........so having this as blueprint an create frontend for the backend code i gave of m-1 andm-2. do it with angular give me the flow and give me each file of codes of every component css,html,ts and all other files codes in vscode to do
