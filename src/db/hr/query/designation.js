import { eq } from 'drizzle-orm';
import {
	handleError,
	handleResponse,
	validateRequest,
} from '../../../util/index.js';
import db from '../../index.js';
import { department, designation, users } from '../schema.js';

export async function insert(req, res, next) {
	if (!(await validateRequest(req, next))) return;

	const designationPromise = db
		.insert(designation)
		.values(req.body)
		.returning({ insertedName: designation.designation });

	try {
		const data = await designationPromise;

		const toast = {
			status: 201,
			type: 'insert',
			message: `${data[0].insertedName} inserted`,
		};

		return res.status(201).json({ toast, data });
	} catch (error) {
		await handleError({ error, res });
	}
}

export async function update(req, res, next) {
	if (!(await validateRequest(req, next))) return;

	const designationPromise = db
		.update(designation)
		.set(req.body)
		.where(eq(designation.uuid, req.params.uuid))
		.returning({ updatedName: designation.designation });

	try {
		const data = await designationPromise;

		const toast = {
			status: 201,
			type: 'update',
			message: `${data[0].updatedName} updated`,
		};

		return res.status(201).json({ toast, data });
	} catch (error) {
		await handleError({ error, res });
	}
}

export async function remove(req, res, next) {
	if (!(await validateRequest(req, next))) return;

	const designationPromise = db
		.delete(designation)
		.where(eq(designation.uuid, req.params.uuid))
		.returning({ deletedName: designation.designation });

	try {
		const data = await designationPromise;

		const toast = {
			status: 200,
			type: 'delete',
			message: `${data[0].deletedName} deleted`,
		};

		return res.status(201).json({ toast, data });
	} catch (error) {
		await handleError({ error, res });
	}
}

export async function selectAll(req, res, next) {
	const resultPromise = db
		.select({
			uuid: designation.uuid,
			designation: designation.designation,
			department_uuid: designation.department_uuid,
			department: department.department,
			created_at: designation.created_at,
			updated_at: designation.updated_at,
			remarks: designation.remarks,
		})
		.from(designation)
		.leftJoin(department, eq(designation.department_uuid, department.uuid));

	const toast = {
		status: 200,
		type: 'select_all',
		message: 'Designation list',
	};

	handleResponse({
		promise: resultPromise,
		res,
		next,
		...toast,
	});
}

export async function select(req, res, next) {
	if (!(await validateRequest(req, next))) return;

	const designationPromise = db
		.select({
			uuid: designation.uuid,
			designation: designation.designation,
			department_uuid: designation.department_uuid,
			department: department.department,
			created_at: designation.created_at,
			updated_at: designation.updated_at,
			remarks: designation.remarks,
		})
		.from(designation)
		.leftJoin(department, eq(designation.department_uuid, department.uuid))
		.where(eq(designation.uuid, req.params.uuid));

	const toast = {
		status: 200,
		type: 'select',
		message: 'Designation',
	};

	handleResponse({
		promise: designationPromise,
		res,
		next,
		...toast,
	});
}
