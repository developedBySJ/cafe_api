import { MigrationInterface, QueryRunner } from 'typeorm'

export class CreateUserTable1620829476230 implements MigrationInterface {
  name = 'CreateUserTable1620829476230'

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      `CREATE TYPE "users_role_enum" AS ENUM('admin', 'customer')`,
    )
    await queryRunner.query(
      `CREATE TABLE "users" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "first_name" character varying(64) NOT NULL, "last_name" character varying(64), "email" character varying(100) NOT NULL, "password" character varying(16) NOT NULL, "date_of_birth" TIMESTAMP WITH TIME ZONE, "role" "users_role_enum" NOT NULL DEFAULT 'customer', "address" character varying(255), "avatar" character varying(512), "created_at" TIMESTAMP NOT NULL DEFAULT now(), "updated_at" TIMESTAMP NOT NULL DEFAULT now(), CONSTRAINT "UQ_97672ac88f789774dd47f7c8be3" UNIQUE ("email"), CONSTRAINT "PK_a3ffb1c0c8416b9fc6f907b7433" PRIMARY KEY ("id"))`,
    )
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP TABLE "users"`)
    await queryRunner.query(`DROP TYPE "users_role_enum"`)
  }
}
