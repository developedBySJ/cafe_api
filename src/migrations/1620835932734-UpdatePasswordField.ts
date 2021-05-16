import { MigrationInterface, QueryRunner } from 'typeorm'

export class UpdatePasswordField1620835932734 implements MigrationInterface {
  name = 'UpdatePasswordField1620835932734'

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "password"`)
    await queryRunner.query(
      `ALTER TABLE "users" ADD "password" character varying NOT NULL`,
    )
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "password"`)
    await queryRunner.query(
      `ALTER TABLE "users" ADD "password" character varying(16) NOT NULL`,
    )
  }
}
